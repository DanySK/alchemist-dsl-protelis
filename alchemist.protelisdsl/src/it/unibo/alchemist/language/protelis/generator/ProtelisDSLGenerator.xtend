/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import it.unibo.alchemist.language.protelis.protelisDSL.Environment
import java.io.File
import java.io.FileInputStream
import java.net.URISyntaxException
import java.net.URL
import java.util.ArrayList
import java.util.StringTokenizer
import java.util.regex.Pattern
import org.apache.commons.io.IOUtils
import org.eclipse.core.runtime.FileLocator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class ProtelisDSLGenerator implements IGenerator {
	
	private static final String INIT = "protelis program"
	private static final String END = "@"
	private static final String PROGRAM_CAPTURING_GROUP_NAME = "program"
	private static final Pattern COMMENT_PATTERN = Pattern.compile("\\s*\\/\\/[^\\n]*\\n|\\/\\*.*?\\*\\/", Pattern.DOTALL)
	/*
	 * 1. Search for the INIT string
	 * 
	 * 2. Match the program name away
	 * 
	 * 3. Capture the whole program, it ends with END
	 */
	private static final Pattern PROGRAM_PATTERN = Pattern.compile(".*?" + INIT + "\\s+\\w+\\s+(?<" + PROGRAM_CAPTURING_GROUP_NAME + ">[^@]+?)\\s*" + END, Pattern.DOTALL)
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val file = doGenerateString(resource)
		val name = new StringTokenizer(resource.URI.lastSegment, ".")
		fsa.generateFile('''«name.nextElement».xml''', file)
	}
	
	def doGenerateString(Resource resource) {
		val url = FileLocator.resolve(new URL(resource.URI.toString))
		val f = try {
				new File(url.toURI)
			} catch (URISyntaxException e) {
				new File(url.path)
			}
		val str = IOUtils.toString(new FileInputStream(f))
		/*
		 * Remove comments
		 */
		val	progString = COMMENT_PATTERN.matcher(str).replaceAll("")
		/*
		 * Scan for programs
		 */
		val progMatcher = PROGRAM_PATTERN.matcher(progString)
		val l = new ArrayList
		while(progMatcher.find) {
			l.add(progMatcher.group(PROGRAM_CAPTURING_GROUP_NAME))
		}
		new EnvironmentGen(resource.allContents.filter(typeof(Environment)).head, l).generateXML(0)
	}
	
}
