package com.github.oehme.sobula

import com.jfrog.bintray.gradle.BintrayExtension
import com.jfrog.bintray.gradle.BintrayPlugin
import com.jfrog.bintray.gradle.BintrayUploadTask
import java.io.File
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.plugins.JavaPluginConvention

class BintrayReleasePlugin implements Plugin<Project> {

	override apply(Project project) {
		val it = project
		plugins.<ReleasePlugin>apply(ReleasePlugin)
		plugins.<BintrayPlugin>apply(BintrayPlugin)

		val bintrayUpload = tasks.getAt("bintrayUpload") as BintrayUploadTask
		bintrayUpload.doFirst [ upload |
			if (project != rootProject) {
				val rootBintrayUpload = rootProject.tasks.getAt("bintrayUpload") as BintrayUploadTask
				val isMultiProjectUpload = gradle.taskGraph.hasTask(rootBintrayUpload)
				if (isMultiProjectUpload) {
					bintrayUpload.syncToMavenCentral = false
					bintrayUpload.signVersion = false
				}
			}
		]
		tasks.getAt(ReleasePlugin.RELEASE_TASK_NAME).dependsOn(bintrayUpload)

		val bintray = extensions.getByType(BintrayExtension) => [
			if (project.hasProperty("bintrayUsername")) {
				user = project.properties.get("bintrayUsername").toString
			}
			if (project.hasProperty("bintrayApiKey")) {
				key = project.properties.get("bintrayApiKey").toString
			}
			publications = "mavenNebula"
			publish = true
			pkg => [
				repo = "maven"
				publicDownloadNumbers = true
				//TODO generalize
				licenses = "EPL-1.0"
				attributes = newHashMap
				version => [
					gpg.sign = true
					if (project.hasProperty("signing.password")) {
						gpg.passphrase = project.property("signing.password").toString
					}
					if (project.hasProperty('sonatypeUsername') && project.hasProperty('sonatypePassword')) {
						mavenCentralSync.sync = true
						mavenCentralSync.user = project.property("sonatypeUsername").toString
						mavenCentralSync.password = project.property("sonatypePassword").toString
					}
					attributes = newHashMap
				]
			]
		]
		afterEvaluate[
			bintray => [
				pkg => [
					name = name ?: project.name
					desc = desc ?: project.description ?: ""
					val gitHubUser = ReleasePlugin.getGitHubUser(project)
					if (gitHubUser != null) {
						websiteUrl = websiteUrl ?: '''https://github.com/«gitHubUser»/«project.rootProject.name»'''
						issueTrackerUrl = issueTrackerUrl ?: '''https://github.com/«gitHubUser»/«project.rootProject.name»/issues'''
						vcsUrl = vcsUrl ?: '''https://github.com/«gitHubUser»/«project.rootProject.name».git'''
					}
					version => [
						name = name ?: project.version.toString
                		vcsTag = vcsTag ?: project.version.toString
                		
                		val possiblePluginProjects = project.subprojects + #[project]
                		val gradlePlugins = newHashSet
                		possiblePluginProjects.forEach [
	                		val java = project.convention.findPlugin(JavaPluginConvention)
	                		if (java != null) {
								val resourceFolders = java.sourceSets.getAt("main").resources
								val gradlePluginsDir = resourceFolders.map[new File(it, 'META-INF/gradle-plugins')].findFirst[exists]
								if (gradlePluginsDir != null) {
									gradlePlugins += gradlePluginsDir.listFiles.map [
										val pluginName = name.replace(".properties", "")
										'''«pluginName»:«project.group»:«project.name»'''
									]
								}
	                		}
                		]
						if (!gradlePlugins.isEmpty) {
							attributes.putAll(#{"gradle-plugin" -> gradlePlugins})
						}
					]
				]
			]
		]
	}
}
