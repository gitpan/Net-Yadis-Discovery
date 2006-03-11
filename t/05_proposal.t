use Test::More tests => 9;
use Data::Dumper;
BEGIN { use_ok('Net::Yadis::Discovery') };

my $disc = Net::Yadis::Discovery->new(debug => 1);
$disc->identity_url("http://example.com");

my $buffer;
foreach (<DATA>) { $buffer .= $_ }

$disc->parse_xrd($buffer);

my @arr = $disc->openid_servers;
is (@arr,4);
@arr = $disc->openid_servers('1.0');
is (@arr,2);
@arr = $disc->openid_servers('1.1');
is (@arr,3);
@arr = $disc->openid_servers(['1.0','1.1']);
is (@arr,4);
@arr = $disc->lid_servers;
is (@arr,2);
@arr = $disc->lid_servers('1.0');
is (@arr,1);
@arr = $disc->lid_servers('2.0');
is (@arr,1);
@arr = $disc->lid_servers(['1.0','2.0']);
is (@arr,2);

__END__
<?xml version="1.0" encoding="UTF-8"?>

<xrds:XRDS
    xmlns:xrds="xri://$xrds"
    xmlns:openid="http://openid.net/xmlns/1.0"
    xmlns:typekey="http://www.sixapart.com/typekey/xmlns/1.0"
    xmlns="xri://$xrd*($v*2.0)">
  <XRD>

    <Service priority="0">
      <Type>http://openid.net/signon/1.0</Type>
      <URI>http://www.myopenid.com/server</URI>
      <openid:Delegate>http://myid.myopenid.com/</openid:Delegate>
    </Service>

    <Service priority="5">
      <Type>http://openid.net/signon/1.0</Type>
      <Type>http://openid.net/signon/1.1</Type>
      <URI>http://www.livejournal.com/openid/server.bml</URI>
      <openid:Delegate>http://www.livejournal.com/users/myid/</openid:Delegate>
    </Service>

    <Service priority="10">
      <Type>http://openid.net/signon/1.1</Type>
      <URI>http://videntity.org/server</URI>
      <openid:Delegate>http://myid.videntity.org/</openid:Delegate>
    </Service>

    <Service priority="15">
      <Type>http://openid.net/signon/1.1</Type>
      <URI>http://auth.mylevel9.com/?action=openid</URI>
      <openid:Delegate>http://mylevel9.com/user/myid</openid:Delegate>
    </Service>

    <Service priority="20">
      <Type>http://www.sixapart.com/typekey/sso/1.0</Type>
      <typekey:MemberName>myid</typekey:MemberName>
    </Service>

    <Service priority="25">
      <Type>http://lid.netmesh.org/sso/2.0</Type>
      <URI>http://mylid.net/myid</URI>
    </Service>

    <Service priority="30">
      <Type>http://lid.netmesh.org/sso/1.0</Type>
      <URI>http://mylid.net/myid</URI>
    </Service>

  </XRD>
</xrds:XRDS>