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
import org.apache.commons.lang.StringUtils
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class ProtelisDSLGenerator implements IGenerator {
	
	private static final String INIT = "field calculus program"
	private static final String END = "@"
	private static final char[] SKIP = #['\n','\t',' ']
	
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
		val sa = StringUtils.splitByWholeSeparator(str, INIT)
		for(var i = 0; i < sa.length; i++) {
			var wholep = sa.get(i)
			if(wholep.contains(END)) {
				var pos = 0
				while(charIsSeparator(wholep.charAt(pos))){
					pos++
				}
				while(!charIsSeparator(wholep.charAt(pos))){
					pos++
				}
				while(charIsSeparator(wholep.charAt(pos))){
					pos++
				}
				l.add(wholep.substring(pos, wholep.indexOf(END)));
			}
		}
		new EnvironmentGen(resource.allContents.filter(typeof(Environment)).head, l).generateXML(0)
	}
	
	def private static charIsSeparator(char c) {
		for(var i=0; i<SKIP.length; i++) {
			if(SKIP.get(i) == c) {
				return true
			}
		}
		return false
	}
	
}
