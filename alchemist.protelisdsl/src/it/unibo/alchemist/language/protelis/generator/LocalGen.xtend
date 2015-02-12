/*
 * Copyright (C) 2010-2015, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

class LocalGen extends ContentLessGen {
	
	new() {
		super("concentration")
	}
	
	override getDescriptionLine() {
		throw new UnsupportedOperationException('''type="Local"''')
	}
	
}