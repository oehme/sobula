package de.oehme.sobula

import com.jfrog.bintray.gradle.BintrayExtension
import com.jfrog.bintray.gradle.BintrayPlugin
import com.jfrog.bintray.gradle.BintrayUploadTask
import org.gradle.api.Plugin
import org.gradle.api.Project

class BintrayReleasePlugin implements Plugin<Project> {

	override apply(Project project) {
		val it = project
		plugins.<ReleasePlugin>apply(ReleasePlugin)
		plugins.<BintrayPlugin>apply(BintrayPlugin)

		val bintrayUpload = tasks.getAt(BintrayUploadTask.TASK_NAME) as BintrayUploadTask
		bintrayUpload.doFirst [ upload |
			if (project != rootProject) {
				val rootBintrayUpload = rootProject.tasks.getAt(BintrayUploadTask.TASK_NAME) as BintrayUploadTask
				val isMultiProjectUpload = gradle.taskGraph.hasTask(rootBintrayUpload)
				if (isMultiProjectUpload) {
					bintrayUpload.syncToMavenCentral = false
					bintrayUpload.signVersion = false
				}
			}
		]
		tasks.getAt(ReleasePlugin.RELEASE_TASK_NAME).dependsOn(bintrayUpload)

		val bintray = extensions.getByType(BintrayExtension) => [
			user = "oehme"
			if (project.hasProperty("bintrayApiKey")) {
				key = project.properties.get("bintrayApiKey") as String
			}
			configurations = "archives"
			publish = true
			pkg => [
				repo = "maven"
				publicDownloadNumbers = true
				licenses = "EPL-1.0"
				websiteUrl = '''https://github.com/oehme/«project.rootProject.name»'''
				issueTrackerUrl = '''https://github.com/oehme/«project.rootProject.name»/issues'''
				vcsUrl = '''https://github.com/oehme/«project.rootProject.name».git'''
				version => [
					gpg.sign = true
					if (project.hasProperty("signing.password")) {
						gpg.passphrase = project.property("signing.password") as String
					}
					if (project.hasProperty('sonatypeUsername') && project.hasProperty('sonatypePassword')) {
						mavenCentralSync.sync = true
						mavenCentralSync.user = project.property("sonatypeUsername") as String
						mavenCentralSync.password = project.property("sonatypePassword") as String
					}
					attributes = #{}
				]
			]
		]
		afterEvaluate[
			bintray => [
				pkg => [
					name = name ?: '''«project.group»:«project.name»'''
					desc = desc ?: project.description
					version => [
						val gradlePluginsDir = project.file("src/main/resources/META-INF/gradle-plugins")
						if (gradlePluginsDir.exists) {
							val gradlePlugins = gradlePluginsDir.listFiles.map [
								val pluginName = name.replace(".properties", "")
								'''«pluginName»:«project.group»:«project.name»'''
							]
							attributes.putAll(#{"gradle-plugin" -> gradlePlugins})
						}
					]
				]
			]
		]
	}
}
