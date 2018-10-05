Run GUI tasks in Pipelines
==========================

*"If you please--draw me a personal X11 virtual frame buffer for each build!"*

## Perks

- [x] Run jobs that require to run graphical process in background
- [x] Create a X11 DISPLAY for a build
- [x] Keep the process alive till as long as you wish

## Requirements

### Jenkins Plugins

This is the list of plugin's shortnames:

* *[workflow-aggregator](https://plugins.jenkins.io/workflow-aggregator)*
* *[xvfb](https://plugins.jenkins.io/xvfb)*

### Jenkinsfile

Importing this `Jenkinsfile` requires a [Pipeline Job](https://jenkins.io/doc/book/pipeline/getting-started/).
It can be imported in two ways:

- Copy/paste the `Jenkinsfile` content from the job's configuration into a [web textarea](https://jenkins.io/doc/book/pipeline/getting-started/#through-the-classic-ui)
- From a [Git repository](https://jenkins.io/doc/book/pipeline/getting-started/#defining-a-pipeline-in-scm) that contains the `Jenkinsfile`

An example of `Jenkinsfile` is given [here](./Jenkinsfile).

## Usage

### Xvfb options

Due to a [lack of documentation](https://wiki.jenkins.io/display/JENKINS/Xvfb+Plugin), we must refer to the  [sources](https://github.com/jenkinsci/xvfb-plugin/blob/master/src/main/java/org/jenkinsci/plugins/xvfb/Xvfb.java#L387).

- These are the wrapper's options:

| Options | Type | Default value | Description
|--|--|--|--|
| installationName | String | "default" | Name of the installation used in a configured job.
| displayName | Integer | unknown  | X11 DISPLAY name, if NULL chosen based on current executor number
| screen | String | "1024x768x24" | Xvfb screen in the form: width x height x pixel depth
| debug | Boolean | false | Should the Xvfb output be displayed in job output
| timeout | Long | 1 | Time in milliseconds to wait for Xvfb initialization, by default 1 second
| displayNameOffset | Integer | false | Offset for display names, default is 1. Display names are taken from build executor's number, i.e. if the build is performed by executor 4, and offset is 100, display name will be 104
| additionalOptions | String | false | Additional options to be passed to Xvfb command
| shutdownWithBuild | Boolean | false | Keep the buffer alive (so all processes run in the wrapper) till the end of the pipeline
| autoDisplayName | Boolean | false | Let Xvfb pick display number
| assignedLabels | String | false | Run only on nodes labeled
| parallelBuild | Boolean | false | Run on same node in parallel

### Xvfb in pipelines

Add the wrapper's option as following:

```groovy
pipeline {
    stages {
        stage("Stage") {
            steps {
                wrap([$class: 'Xvfb',
                      screen: "640x480x16",
                      autoDisplayName: true,
                      shutdownWithBuild:true]) {
                    sh('nohup gedit &')
                }
            }
        }
    }
}
```
