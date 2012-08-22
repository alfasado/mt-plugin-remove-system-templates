package RemoveSystemTemplates::Plugin;
use strict;

sub _remove_system_templates {
    my $app = shift;
    my @id = $app->param( 'id' ) or return $app->errtrans( 'Invalid request.' );
    my $user = $app->user;
    my $perms = $app->permissions;
    my $admin = $user->is_superuser
      || ( $perms && $perms->can_administer_blog );
    my $edit_templates = $admin
      || ( $perms
        && ( $perms->edit_templates ) )
      ? 1 : 0;
    if (! $edit_templates ) {
        return $app->trans_error( 'Permission denied.' );
    }
    my $blog_id = 0;
    if ( $app->blog ) {
        $blog_id = $app->blog->id;
    }
    my $do;
    for my $id ( @id ) {
        my $tmpl = MT::Template->load( { blog_id => $blog_id, id =>$id } );
        next unless defined $tmpl;
        $tmpl->remove or die $tmpl->errstr;
        $do = 1;
    }
    $app->add_return_arg( saved => 1 );
    $app->call_return;
}

sub _list_widget {
    my ( $cb, $app, $tmpl ) = @_;
    $$tmpl =~ s!(<form\sid="widget-listing-form".*?)<option\svalue="removesystemtemplates">.*?</option>!$1!s;
    $$tmpl =~ s!(<form\sid="widget-listing-form".*?)<option\svalue="removesystemtemplates">.*?</option>!$1!s;
}

sub _list_template {
    my ( $cb, $app, $tmpl ) = @_;
    $$tmpl =~ s!(<form\sid="index-listing-form".*?)<option\svalue="removesystemtemplates">.*?</option>!$1!s;
    $$tmpl =~ s!(<form\sid="index-listing-form".*?)<option\svalue="removesystemtemplates">.*?</option>!$1!s;
    $$tmpl =~ s!(<form\sid="archive-listing-form".*?)<option\svalue="removesystemtemplates">.*?</option>!$1!s;
    $$tmpl =~ s!(<form\sid="archive-listing-form".*?)<option\svalue="removesystemtemplates">.*?</option>!$1!s;
    $$tmpl =~ s!(<form\sid="module-listing-form".*?)<option\svalue="removesystemtemplates">.*?</option>!$1!s;
    $$tmpl =~ s!(<form\sid="module-listing-form".*?)<option\svalue="removesystemtemplates">.*?</option>!$1!s;
}

sub _edit_template {
    my ( $cb, $app, $tmpl ) = @_;
    $$tmpl =~ s!(<form\sname="template-listing-form".*?)<option\svalue="removesystemtemplates">.*?</option>!$1!s;
}

1;