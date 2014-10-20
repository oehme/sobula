package de.oehme.sobula

import groovy.lang.Closure
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.plugins.JavaPlugin
import org.gradle.api.plugins.JavaPluginConvention
import org.gradle.api.tasks.bundling.Jar
import org.gradle.api.tasks.javadoc.Javadoc
import org.gradle.plugins.signing.SigningExtension
import org.gradle.plugins.signing.SigningPlugin

import static de.oehme.sobula.ReleasePlugin.*

class ReleasePlugin implements Plugin<Project> {
	static val ARCHIVES = "archives"

	override apply(Project it) {
		plugins.<SigningPlugin>apply(SigningPlugin)

		val release = tasks.create("release") [
			description = "Releases archives to public repositories"
		]

		val java = convention.getPlugin(JavaPluginConvention)
		val jar = tasks.getAt(JavaPlugin.JAR_TASK_NAME) as Jar
		val javadoc = tasks.getAt(JavaPlugin.JAVADOC_TASK_NAME) as Javadoc

		val javaDocJar = tasks.create("javaDocJar", Jar) [
			classifier = "javadoc"
			from(javadoc.destinationDir)
		]
		val sourcesJar = tasks.create("sourcesJar", Jar) [
			classifier = "sources"
			from(java.sourceSets.getAt("main").allSource)
		]
		project.artifacts.add(ARCHIVES, jar)
		project.artifacts.add(ARCHIVES, javaDocJar)
		project.artifacts.add(ARCHIVES, sourcesJar)

		project.extensions.getByType(SigningExtension) => [
			required = new Closure<Boolean>(null) {
				override call() {
					project.gradle.taskGraph.hasTask(release)
				}
			}
			sign(project.configurations.getAt(ARCHIVES))
		]
	}
}
