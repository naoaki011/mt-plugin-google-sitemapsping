package MT::Plugin::GoogleSitemapsPing;
#	MTGoogleSitemapsPing - Google Sitemaps に URL の更新 ping を送信する
#	@see http://www.magicvox.net/archive/2006/05201647.php
#			Programmed by Piroli YUKARINOMIYA (MagicVox)
#			Open MagicVox.net - http://www.magicvox.net/
use strict;
use MT::Plugin;
use base qw( MT::Plugin );
use vars qw($PLUGIN_NAME $VERSION $DESCRIPTION);
$PLUGIN_NAME = 'GoogleSitemapsPing';
$VERSION = '0.10';
$DESCRIPTION = 'Ping to Google Sitemaps to notify updating of the file.';

use MT;
use MT::Util;
use MT::Template::Context;
use LWP::UserAgent;# for ping

my $plugin = MT::Plugin::GoogleSitemapsPing->new({
    id => 'googlesitemapsping',
    key => __PACKAGE__,
    name => $PLUGIN_NAME,
    version => $VERSION,
    description => $DESCRIPTION,
    doc_link => 'http://www.magicvox.net/archive/2006/05201647.php',
    author_name => 'Piroli YUKARINOMIYA',
    author_link => 'http://www.magicvox.net/',
    l10n_class => 'GoogleSitemapsPing::L10N',
    registry => {
        tags => {
            function => {
                'GoogleSitemapsPing'          => \&google_sitemaps_ping,
            },

        },
    },
});

MT->add_plugin($plugin);

sub instance { $plugin; }

### $MTGoogleSitemapsPing$
sub google_sitemaps_ping {
	my ($ctx, $args, $cond) = @_;
#
	# テンプレート
	my $template = $args->{template}
		or return sprintf 'MT%s error: <template> should be specified.',
				$ctx->stash('tag');
#	my $file_url = MT::Template::Context::_hdlr_link (
	my $file_url = MT::Template::Tags::System::_hdlr_link (
			$ctx, {'template' => $template}, $cond)
		or return sprintf 'MT%s error: a template which named "%s" is not found.',
				$ctx->stash('tag'), $template;

	# 前回の ping 送信時間をプラグインデータから取得
	my $cur_time = time ();
	my $last_ping_time = load_plugindata ($file_url);# ref

	# ping 送信間隔 [分] 以内であれば、ping は送信しない
	my $period = $args->{period} || 0;
	$period = 60 if $period < 60;# cf. サイトマップは 1 時間に 2 回以上再送信しないことをお勧めします。
	return sprintf 'MT%s message: You need not to ping for "%s" now.',
			$ctx->stash('tag'), $file_url
		if defined $last_ping_time && $cur_time < $$last_ping_time + $period * 60;

	# Google Sitemaps に更新 ping を送信する
	MT::Util::start_background_task (sub {
			my $app = MT::App->instance;
			my $ping_url = sprintf 'http://www.google.com/webmasters/sitemaps/ping?sitemap=%s',
					MT::Util::encode_url ($file_url);
			my $ua = LWP::UserAgent->new;
			if ($ua) {
				$ua->timeout (30);
				my $response = $ua->get ($ping_url);
				if (! $response->is_success) {
					$app->log (sprintf 'MT%s error: failed to ping. destination server returns; %s',
							$ctx->stash('tag'), $response->status_line);
				}
			}
			else {
				$app->log (sprintf 'MT%s error: failed to initialize LWP::UserAgent',
						$ctx->stash('tag'));
			}
	});

	# ping 送信時刻を更新
	save_plugindata ($file_url, \$cur_time);
	return sprintf 'MT%s message: Successfully pinged for "%s" at %s.',
			$ctx->stash('tag'), $file_url, scalar localtime ($cur_time);
}



########################################################################
use MT::PluginData;
sub load_plugindata {
	my ($key) = @_;
	my $plugindata = MT::PluginData->load ({ plugin => __PACKAGE__, key => $key })
			or return undef;
	return $plugindata->data;
}

sub save_plugindata {
	my ($key, $data) = @_;
	my $plugindata = MT::PluginData->load ({ plugin => __PACKAGE__, key => $key });
	if (! $plugindata) {
		$plugindata = MT::PluginData->new;
		$plugindata->plugin (__PACKAGE__);
		$plugindata->key ($key);
	}
	$plugindata->data ($data);
	$plugindata->save;
}

1;