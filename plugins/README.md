## Jenkins Plugins

The pipeline needs some Jenkins plugins to run. A script can easily install
the plugins performing remote commands:

>**admin credentials are required**

* First, download the sources:

```bash
$ git clone https://git.smile.fr/ecs-ci/jenkins-pipeline-python.git
$ cd jenkins-pipeline-python/
```

* Install the plugins (asks for username/password):

```bash
# ./install-plugins.sh "<jenkins-base-url>"
./install-plugins.sh "http://ci1:8080"
```
