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
import java.net.URI
import java.util.ArrayList
import java.util.StringTokenizer
import org.apache.commons.io.IOUtils
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import java.util.regex.Pattern

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
		val l = new ArrayList
		val platformString = resource.URI.toPlatformString(true);
		val asd = (ResourcesPlugin.getWorkspace.root as IResource).locationURI + platformString
		val f = new File(new URI(asd))
		val str = IOUtils.toString(new FileInputStream(f))
		/*
		 * Remove comments
		 */
		val	progString = COMMENT_PATTERN.matcher(str).replaceAll("")
		/*
		 * Scan for programs
		 */
		val progMatcher = PROGRAM_PATTERN.matcher(progString)
		while(progMatcher.find) {
			l.add(progMatcher.group(PROGRAM_CAPTURING_GROUP_NAME))
		}
		new EnvironmentGen(resource.allContents.filter(typeof(Environment)).head, l).generateXML(0)
	}
	
}
