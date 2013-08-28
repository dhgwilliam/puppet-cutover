# dhgwilliam-cutover documentation


## Assumptions

* You have two trusted puppet masters (you'll be giving your
  `old-master` full control over the `new-master` CA)
* The `old-master` is Puppet Open Source and the `new-master` is Puppet
  Enterprise; this shouldn't be required, and the module should be updated 
  shortly to reflect a more generalized use case


## 10,000 Feet

Basically, the `cutover` module is intended to aid you in the process of moving
an agent node between two "trusted" masters. 

Given a configuration of `old-master`, `new-master`, and `agent`, the
module is applied as such:

~~~
# manifests/site.pp on old-master

node 'agent.puppet.labs' {
  class { 'cutover':
    new_master => 'new-master.puppet.labs',
    old_master => 'old-master.puppet.labs',
  }
}
~~~

This currently utilizes the `cutover::pitcher` class to apply the
necessary changes to the agent and the `new-master` CA to hand it over
to the `new-master`; a `cutover::catcher` class should be implemented
soon which will take care of the changes necessary to clean up after the
handoff.


## laying the groundwork

In order for this to work, we utilize the fingerpuppet gem to manipulate
the CA on `new-master`. Start with:
        
### on old-master.puppet.labs

~~~
gem install fingerpuppet
env HOME=/var/lib/puppet fingerpuppet --init --server new-master.puppet.labs --certname old-master.puppet.labs
~~~

### on new-master.puppet.labs

~~~
puppet cert list  # confirm that the old-master has successfully submitted a CSR
puppet cert sign old-master.puppet.labs
~~~

find the following stanza in `/etc/puppetlabs/puppet/auth.conf` and update it accordingly:

~~~
  path  /certificate_status
  method find, search, save, destroy
  auth yes
- allow pe-internal-dashboard
+ allow pe-internal-dashboard, old-master.puppet.labs
~~~

### back on old-master.puppet.labs

~~~
env HOME=/var/lib/puppet fingerpuppet --install
env HOME=/var/lib/puppet fingerpuppet --cert_status old-master.puppet.labs  
# output should resemble the following:
{"fingerprint":"0E:0D:62:35:A2:0E:3B:7B:D5:0E:92:56:B0:DF:44:67","state":"signed","dns_alt_names":[],"name":"old-master.puppet.labs","fingerprints":{"SHA512":"7F:2E:3F:6D:B5:66:B1:98:5F:7F:D9:0A:81:B7:63:AD:23:ED:F2:33:DD:F1:56:F2:13:53:4B:AC:BE:15:14:B2:55:A5:23:63:32:63:55:CE:A9:49:DB:F8:7D:58:DB:19:FF:BC:AF:98:95:22:20:F2:5D:AF:4D:4D:B6:A9:B1:DE","MD5":"0E:0D:62:35:A2:0E:3B:7B:D5:0E:92:56:B0:DF:44:67","SHA256":"6D:40:B3:1E:0A:E6:84:3A:94:B7:B7:57:33:B3:FC:0F:80:7C:1A:8D:FB:5E:67:01:44:FE:CD:54:F6:16:0A:EF","default":"0E:0D:62:35:A2:0E:3B:7B:D5:0E:92:56:B0:DF:44:67","SHA1":"33:21:42:B2:0D:04:0B:D0:DA:F5:D8:A7:4D:25:3A:DC:84:DB:1A:4B"}}
~~~


## What happens

After three puppet runs, the `agent` node should be successfully "handed
off" to the `new-master`:

- After the first run, the agent node generates a new SSL private key and submits a 
  CSR to the `new-master`, and the CA cert is retrieved
- After the second run, the CSR is signed and the `agent`'s private cert is
  retrieved
- After the third run, the `agent`'s puppet.conf is updated to take
  advantage of the new `$ssldir` and the `server` and `ca_server` config directives 
  are set to `new-master`
- On the next run, the `agent` should run against `new-master` instead
  of `old-master`


## Errata

The folder `old-master:/var/lib/puppet/.fingerpuppet` may become relevant
to your life.
