package com.github.oehme.sobula

import com.jfrog.bintray.gradle.BintrayExtension
import com.jfrog.bintray.gradle.BintrayPlugin
import com.jfrog.bintray.gradle.BintrayUploadTask
import org.gradle.api.Plugin
import org.gradle.api.Project

import static extension com.github.oehme.sobula.ReleasePlugin.*

class BintrayReleasePlugin implements Plugin<Project> {

	override apply(Project project) {
		val it = project
		plugins.<ReleasePlugin>apply(ReleasePlugin)
		plugins.<BintrayPlugin>apply(BintrayPlugin)

		val bintrayUpload = bintrayUpload
		bintrayUpload.doFirst [ upload |
			if (project != rootProject) {
				val rootBintrayUpload = rootProject.bintrayUpload
				val isMultiProjectUpload = gradle.taskGraph.hasTask(rootBintrayUpload)
				if (isMultiProjectUpload) {
					bintrayUpload.syncToMavenCentral = false
					bintrayUpload.signVersion = false
				}
			}
		]
		
		tasks.getAt(ReleasePlugin.RELEASE_TASK_NAME).dependsOn(bintrayUpload)

		bintray => [
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
				attributes = newHashMap
				version => [
					gpg.sign = true
					if (project.hasProperty("signingPassword")) {
						gpg.passphrase = project.property("signingPassword").toString
					}
					mavenCentralSync.sync = true
					if (project.hasProperty('sonatypeUsername')) {
						mavenCentralSync.user = project.property("sonatypeUsername").toString
					}
					if (project.hasProperty('sonatypePassword')) {
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
					val gitHubUser = project.gitHubUser
					if (gitHubUser != null) {
						websiteUrl = websiteUrl ?: '''https://github.com/«gitHubUser»/«project.rootProject.name»'''
						issueTrackerUrl = issueTrackerUrl ?: '''https://github.com/«gitHubUser»/«project.rootProject.name»/issues'''
						vcsUrl = vcsUrl ?: '''https://github.com/«gitHubUser»/«project.rootProject.name».git'''
					}
					if (licenses == null || licenses.isEmpty) {
						val license = project.license
						if (license != null) {
							licenses = license.id
						}
					}
					version => [
						name = name ?: project.version.toString
                		vcsTag = vcsTag ?: project.version.toString
					]
				]
			]
		]
	}
	
	private def bintray(Project it) {
		extensions.getByType(BintrayExtension)
	}
	
	private def bintrayUpload(Project it) {
		tasks.getAt("bintrayUpload") as BintrayUploadTask
	}
}
