/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

abstract class GenericGen implements XMLGenerator {
	
	private final CharSequence tag;
	
	new(String tagname){
		tag = tagname
	}
	
	override final generateXML(int i) {
'''«Utils.indent(i)»<«tag» «getDescriptionLine()»>«IF hasContent()»
«Utils.indent(i+1)»«getContent(i+1)»«Utils.indent(i)»«ENDIF»</«tag»>'''
	}
	
	def abstract CharSequence getContent(int i)
	
	def abstract boolean hasContent()
	
	def abstract CharSequence getDescriptionLine();
	
}