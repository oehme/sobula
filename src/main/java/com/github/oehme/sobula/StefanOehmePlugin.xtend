package com.github.oehme.sobula

import nebula.plugin.contacts.BaseContactsPlugin
import nebula.plugin.contacts.Contact
import nebula.plugin.contacts.ContactsExtension
import org.gradle.api.Plugin
import org.gradle.api.Project
import com.jfrog.bintray.gradle.BintrayExtension

class StefanOehmePlugin implements Plugin<Project> {
	override apply(Project it) {
		plugins.<BaseContactsPlugin>apply(BaseContactsPlugin)
		val contacts = project.extensions.getByType(ContactsExtension)
		contacts.addPerson("st.oehme@gmail.com") as Contact => [
			moniker = "Stefan Oehme"
			roles = #{"owner"}
			github = "oehme"
			twitter = "StefanOehme"
		]
		plugins.withType(BintrayReleasePlugin) [ plugin |
			extensions.getByType(BintrayExtension) => [
				user = "oehme"
				pkg.version.mavenCentralSync.user = "oehme"
			]
		]
	}
}
