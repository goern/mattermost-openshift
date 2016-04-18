# Matterbridge-plus for Mattermost 2.1.0+

This is the Matterbridge-plus, a bridge between IRC and Mattermost.

## Prerequisites

OpenShift Origin 3 up and running, including the capability to create a new
project. Access to IRC and a Mattermost instance.


## Installation

```
oc project mattermost

oc new-app -f https://raw.githubusercontent.com/goern/mattermost-openshift/centos7/matterbridge-plus/matterbridge-plus.yaml
```


## Usage

Point your browser at `mattermost.example.com`, join the channel you configure
on IRC


## Copyright

Copyright (C) 2016 Red Hat Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

The GNU General Public License is provided within the file LICENSE.
