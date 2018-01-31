#
# Copyright (c) .NET Foundation and contributors. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
#

[cmdletbinding()]
param(
    [string]$UpdateDependenciesParams,
    [switch]$CleanupDocker
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    & docker build -t update-dependencies -f $PSScriptRoot\Dockerfile $PSScriptRoot\..
    if ($LastExitCode -ne 0) {
        throw "Failed building update-dependencies"
    }

    Invoke-Expression "docker run --rm update-dependencies $UpdateDependenciesParams"
    if ($LastExitCode -ne 0) {
        throw "Failed to update dependencies"
    }
}
finally {
    if ($CleanupDocker){
        & docker rmi -f update-dependencies
        & docker system prune -f
    }
}
