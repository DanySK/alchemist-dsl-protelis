/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import it.unibo.alchemist.language.protelis.protelisDSL.Position

class PositionGen extends ContentLessGen {

	private final CharSequence descLine;
	private static final String DEFAULT = "Continuous2DEuclidean"

	new(Position obj) {
		super("position")
		if(obj == null) {
			descLine = Utils.checkDefault(DEFAULT)
		} else {
			descLine = Utils.checkDefault(obj.type, DEFAULT)
		}
	}
	
	override getDescriptionLine() {
		descLine
	}

}
