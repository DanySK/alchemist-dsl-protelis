/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import java.util.Map
import java.util.Objects
import it.unibo.alchemist.language.protelis.protelisDSL.Action
import it.unibo.alchemist.language.protelis.protelisDSL.JavaConstructor

class ActionGen extends ContentLessGen {
	
	private final CharSequence name
	private final CharSequence typeDesc
	
	public new(Action act, int pn, int rn, int an, Map<String, String> varmap) {
		this(act.type, pn, rn, an, varmap)
	}
	
	public new(JavaConstructor act, int pn, int rn, int an, Map<String, String> varmap){
		super("action")
		Objects.requireNonNull(act)
		name = Utils.genActName(pn,rn,an)
		typeDesc = Utils.convertJavaConstructor(act, varmap)
	}
	
	override getDescriptionLine() {
		'''name="«name»" «typeDesc»'''
	}
	
}