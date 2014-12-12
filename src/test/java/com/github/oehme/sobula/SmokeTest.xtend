package com.github.oehme.sobula

import org.gradle.testfixtures.ProjectBuilder
import org.junit.Test
import org.gradle.api.internal.project.ProjectInternal

class SmokeTest {
	@Test
	def void test() {
		val project = ProjectBuilder.builder.withName("foo").build as ProjectInternal
		project.plugins.<BintrayReleasePlugin>apply(BintrayReleasePlugin)
		project.plugins.<StefanOehmePlugin>apply(StefanOehmePlugin)
		project.evaluate
	}
}