package de.oehme.sobula

import org.gradle.api.Project
import org.gradle.api.Plugin
import com.jfrog.bintray.gradle.BintrayPlugin
import com.jfrog.bintray.gradle.BintrayExtension

class BintrayReleasePlugin implements Plugin<Project> {

	override apply(Project project) {
		val it = project
		plugins.<ReleasePlugin>apply(ReleasePlugin)
		plugins.<BintrayPlugin>apply(BintrayPlugin)
		tasks.getAt(ReleasePlugin.RELEASE_TASK_NAME).dependsOn("bintrayUpload")
		afterEvaluate[
			extensions.getByType(BintrayExtension) => [
				user = "oehme"
				if (project.hasProperty("bintrayApiKey")) {
					key = project.properties.get("bintrayApiKey") as String
				}
				configurations = "archives"
				publish = true
				pkg => [
					repo = "maven"
					name = '''«project.group»:«project.name»'''
					desc = project.description
					publicDownloadNumbers = true
					licenses = "EPL-1.0"
					websiteUrl = '''https://github.com/oehme/«project.rootProject.name»'''
					issueTrackerUrl = '''https://github.com/oehme/«project.rootProject.name»/issues'''
					vcsUrl = '''https://github.com/oehme/«project.rootProject.name».git'''
					version => [
						val gradlePluginsDir = project.file("src/main/resources/META-INF/gradle-plugins")
						if (gradlePluginsDir.exists) {
							val gradlePlugins = gradlePluginsDir.listFiles.map [
								val pluginName = name.replace(".properties", "")
								'''«pluginName»:«project.group»:«project.name»'''
							]
							attributes = #{"gradle-plguin" -> gradlePlugins}
						}
					]
				]
			]
		]
	}
}
