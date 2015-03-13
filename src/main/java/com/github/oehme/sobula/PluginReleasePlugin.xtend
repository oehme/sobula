package com.github.oehme.sobula

import com.jfrog.bintray.gradle.BintrayExtension
import java.io.File
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.plugins.JavaPluginConvention

class PluginReleasePlugin implements Plugin<Project> {

	override apply(Project project) {
		project.plugins.<BintrayReleasePlugin>apply(BintrayReleasePlugin)
		project.afterEvaluate [
			val gradlePlugins = allprojects.map[gradlePluginDefinitions].flatten.toSet
			allprojects.forEach[
				val bintray = extensions.findByType(BintrayExtension)
				if (bintray != null) {
					bintray => [
						pkg => [
							version => [
								if (!attributes.containsKey("gradle-plugin")) {
									if (!gradlePlugins.isEmpty) {
										attributes.put("gradle-plugin", gradlePlugins)
									}
								}
							]
						]
					]
				}
			]
		]
	}

	private def getGradlePluginDefinitions(Project subProject) {
		val java = subProject.convention.findPlugin(JavaPluginConvention)
		if (java != null) {
			val mainSourceSet = java.sourceSets.getAt("main")
			if (mainSourceSet != null) {
				val resourceFolders = mainSourceSet.resources.srcDirs
				val gradlePluginsDir = resourceFolders.map[new File(it, 'META-INF/gradle-plugins')].findFirst[exists]
				if (gradlePluginsDir != null) {
					return gradlePluginsDir.listFiles.map [
						val pluginName = name.replace(".properties", "")
						'''«pluginName»:«subProject.group»:«subProject.name»'''
					].toSet
				}
			}
		}
		return #{}
	}
}
