#!/bin/bash

# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

KOMPOSE_ROOT=$(readlink -f $(dirname "${BASH_SOURCE}")/../../..)
source $KOMPOSE_ROOT/script/test/cmd/lib.sh

#######
# Tests related to docker-compose file in /script/test/fixtures/etherpad
convert::expect_failure "kompose -f $KOMPOSE_ROOT/script/test/fixtures/etherpad/docker-compose.yml convert --stdout"

# commenting this test case out until image handling is fixed
#convert::expect_failure "kompose -f $KOMPOSE_ROOT/script/test/fixtures/etherpad/docker-compose-no-image.yml convert --stdout"
convert::expect_warning "kompose -f $KOMPOSE_ROOT/script/test/fixtures/etherpad/docker-compose-no-ports.yml convert --stdout" "Service cannot be created because of missing port."
export $(cat $KOMPOSE_ROOT/script/test/fixtures/etherpad/envs)
# kubernetes test
convert::expect_success_and_warning "kompose -f $KOMPOSE_ROOT/script/test/fixtures/etherpad/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/etherpad/output-k8s.json" "Unsupported key depends_on - ignoring"
# openshift test
convert::expect_success_and_warning "kompose --provider=openshift -f $KOMPOSE_ROOT/script/test/fixtures/etherpad/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/etherpad/output-os.json" "Unsupported key depends_on - ignoring"
unset $(cat $KOMPOSE_ROOT/script/test/fixtures/etherpad/envs | cut -d'=' -f1)

######
# Tests related to docker-compose file in /script/test/fixtures/gitlab
convert::expect_failure "kompose -f $KOMPOSE_ROOT/script/test/fixtures/gitlab/docker-compose.yml convert --stdout"
export $(cat $KOMPOSE_ROOT/script/test/fixtures/gitlab/envs)
# kubernetes test
convert::expect_success "kompose -f $KOMPOSE_ROOT/script/test/fixtures/gitlab/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/gitlab/output-k8s.json"
# openshift test
convert::expect_success "kompose --provider=openshift -f $KOMPOSE_ROOT/script/test/fixtures/gitlab/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/gitlab/output-os.json"
unset $(cat $KOMPOSE_ROOT/script/test/fixtures/gitlab/envs | cut -d'=' -f1)

######
# Tests related to docker-compose file in /script/test/fixtures/ngnix-node-redis
# kubernetes test
convert::expect_success_and_warning "kompose -f $KOMPOSE_ROOT/script/test/fixtures/ngnix-node-redis/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/ngnix-node-redis/output-k8s.json" "Unsupported key build - ignoring"
# openshift test
convert::expect_success_and_warning "kompose --provider=openshift -f $KOMPOSE_ROOT/script/test/fixtures/ngnix-node-redis/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/ngnix-node-redis/output-os.json" "Unsupported key build - ignoring"


######
# Tests related to docker-compose file in /script/test/fixtures/entrypoint-command
# kubernetes test
convert::expect_success_and_warning "kompose -f $KOMPOSE_ROOT/script/test/fixtures/entrypoint-command/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/entrypoint-command/output-k8s.json" "Service cannot be created because of missing port."
# openshift test
convert::expect_success_and_warning "kompose --provider=openshift -f $KOMPOSE_ROOT/script/test/fixtures/entrypoint-command/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/entrypoint-command/output-os.json" "Service cannot be created because of missing port."


######
# Tests related to docker-compose file in /script/test/fixtures/ports-with-proto
# kubernetes test
convert::expect_success "kompose -f $KOMPOSE_ROOT/script/test/fixtures/ports-with-proto/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/ports-with-proto/output-k8s.json"
# openshift test
convert::expect_success "kompose --provider=openshift -f $KOMPOSE_ROOT/script/test/fixtures/ports-with-proto/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/ports-with-proto/output-os.json"


######
# Tests related to docker-compose file in /script/test/fixtures/volume-mounts/simple-vol-mounts
# kubernetes test
convert::expect_success "kompose -f $KOMPOSE_ROOT/script/test/fixtures/volume-mounts/simple-vol-mounts/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/volume-mounts/simple-vol-mounts/output-k8s.json"
# openshift test
convert::expect_success "kompose --provider=openshift -f $KOMPOSE_ROOT/script/test/fixtures/volume-mounts/simple-vol-mounts/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/volume-mounts/simple-vol-mounts/output-os.json"


######
# Tests related to docker-compose file in /script/test/fixtures/volume-mounts/volumes-from
# kubernetes test
convert::expect_success_and_warning "kompose -f $KOMPOSE_ROOT/script/test/fixtures/volume-mounts/volumes-from/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/volume-mounts/volumes-from/output-k8s.json" "ignoring path on the host"
# openshift test
convert::expect_success_and_warning "kompose --provider=openshift -f $KOMPOSE_ROOT/script/test/fixtures/volume-mounts/volumes-from/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/volume-mounts/volumes-from/output-os.json" "ignoring path on the host"


######
# Tests related to docker-compose file in /script/test/fixtures/envvars-separators
# kubernetes test
convert::expect_success_and_warning "kompose -f $KOMPOSE_ROOT/script/test/fixtures/envvars-separators/docker-compose.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/envvars-separators/output-k8s.json"

######
# Tests related to unknown arguments with cli commands
convert::expect_failure "kompose up $KOMPOSE_ROOT/script/test/fixtures/gitlab/docker-compose.yml" "Unknown Argument docker-gitlab.yml"
convert::expect_failure "kompose down $KOMPOSE_ROOT/script/test/fixtures/gitlab/docker-compose.yml" "Unknown Argument docker-gitlab.yml"
convert::expect_failure "kompose convert $KOMPOSE_ROOT/script/test/fixtures/gitlab/docker-compose.yml" "Unknown Argument docker-gitlab.yml"

# Tests related to kompose --bundle convert usage and that setting the compose file results in a failure
convert::expect_failure "kompose -f $KOMPOSE_ROOT/script/test/fixtures/bundles/foo.yml --bundle $KOMPOSE_ROOT/script/test/fixtures/bundles/dab/docker-compose-bundle.dab convert"

######
# Test related to kompose --bundle convert to ensure that docker bundles are converted properly
convert::expect_success "kompose --bundle $KOMPOSE_ROOT/script/test/fixtures/bundles/dab/docker-compose-bundle.dab convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/bundles/dab/output-k8s.json"

######
# Test related to kompose --bundle convert to ensure that DSB bundles are converted properly
convert::expect_success_and_warning "kompose --bundle $KOMPOSE_ROOT/script/test/fixtures/bundles/dsb/docker-voting-bundle.dsb convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/bundles/dsb/output-k8s.json" "Service cannot be created because of missing port."


######
# Test related to restart options in docker-compose
# kubernetes test
convert::expect_success "kompose -f $KOMPOSE_ROOT/script/test/fixtures/restart-options/docker-compose-restart-no.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/restart-options/output-k8s-restart-no.json"
convert::expect_success "kompose -f $KOMPOSE_ROOT/script/test/fixtures/restart-options/docker-compose-restart-onfail.yml convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/restart-options/output-k8s-restart-onfail.json"
# openshift test
convert::expect_success "kompose -f $KOMPOSE_ROOT/script/test/fixtures/restart-options/docker-compose-restart-no.yml --provider openshift convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/restart-options/output-os-restart-no.json"
convert::expect_success "kompose -f $KOMPOSE_ROOT/script/test/fixtures/restart-options/docker-compose-restart-onfail.yml --provider openshift convert --stdout" "$KOMPOSE_ROOT/script/test/fixtures/restart-options/output-os-restart-onfail.json"

exit $EXIT_STATUS
