#!/usr/bin/groovy

/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2018-2019 Thomas "Ventto" Venriès <thomas.venries@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
plugins = [
    "build-timeout",
    "timestamper",
    "workflow-aggregator",
    "ws-cleanup",
    "warnings"
]

def num_installed = 0
def num_notinstalled = 0

def updateCenter = Jenkins.instance.updateCenter

for (name in plugins) {
    def plugin = updateCenter.getPlugin(name)
    def isInstalled = plugin.getInstalled()
    if (isInstalled) {
        println name + " is already installed"
    } else {
        try {
            num_notinstalled++
            plugin.doInstallNow()
            println name + " has been installed"
            num_installed++
        } catch(IOException ex) {
            println(name + " installation has failed with the following message:"
                    + ex.getMessage() + "\n")
        }
    }
}

if (num_notinstalled) {
	println("\nInstalled plugins: " + num_installed + "/" + num_notinstalled
            + "\n")
} else {
  	println("\nNothing to install\n")
}

if (updateCenter.isRestartRequiredForCompletion()) {
    println("Jenkins requires to restart for completion.")
}
