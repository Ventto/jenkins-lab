#!/usr/bin/groovy

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
