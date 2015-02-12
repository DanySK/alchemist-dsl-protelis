/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import it.unibo.alchemist.language.protelis.protelisDSL.RandomEngine

class RandomEngineGen extends ContentLessGen {

	private final CharSequence descLine;

	new(RandomEngine obj) {
		super("random")
		descLine = '''«IF obj == null || obj.type == null»type="MersenneTwister"«ELSE»type="«obj.type»«ENDIF» seed="«IF obj == null || obj.seed == null»RANDOM«ELSE»«obj.seed»«ENDIF»"'''
	}
	
	override getDescriptionLine() {
		descLine
	}

}
