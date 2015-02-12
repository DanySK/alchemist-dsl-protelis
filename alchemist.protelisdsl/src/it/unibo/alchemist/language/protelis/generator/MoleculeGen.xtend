/*
 * Copyright (C) 2010-2015, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import it.unibo.alchemist.language.protelis.protelisDSL.Content

class MoleculeGen extends ContentLessGen {
	
	private final CharSequence name
	private final CharSequence typeDesc
	
	def private static c(String s) {
		Utils.checkForSpecialCharacter(s)
	}
	
	new(Content content) {
		super("molecule")
		name=c(content.name)
		typeDesc = '''type="Molecule" p0="«name»"'''
	}
	
	override getDescriptionLine() {
		'''name="«name»" «typeDesc»'''
	}
	
}