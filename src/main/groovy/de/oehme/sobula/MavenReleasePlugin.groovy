package de.oehme.sobula

import org.gradle.api.Project
import org.gradle.api.Plugin

public class MavenReleasePlugin implements Plugin<Project> {

	public void apply(Project project) {
		project.with {
			apply plugin: 'maven'
			apply plugin: ReleasePlugin
			release.dependsOn(uploadArchives)
			uploadArchives {
				repositories {
					mavenDeployer {
						beforeDeployment { deployment -> signing.signPom(deployment) }

						repository(url: "https://oss.sonatype.org/service/local/staging/deploy/maven2/") {
							if (project.hasProperty('sonatypePassword')) {
								authentication(userName: sonatypeUsername, password: sonatypePassword)
							}
						}

						pom.project {
							name project.name
							description project.description
							packaging 'jar'
							url "https://github.com/oehme/${rootProject.name}"

							scm {
								url "scm:git@github.com:oehme/${rootProject.name}.git"
								connection "scm:git@github.com:oehme/${rootProject.name}.git"
								developerConnection "scm:git@github.com:oehme/${rootProject.name}.git"
							}

							licenses {
								license {
									name 'Eclipse Public License - v 1.0'
									url 'http://www.eclipse.org/org/documents/epl-v10.php'
									distribution 'repo'
								}
							}

							developers {
								developer {
									id 'oehme'
									name 'Stefan Oehme'
								}
							}
						}
					}
				}
			}
		}
	}
}