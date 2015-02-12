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
import it.unibo.alchemist.language.protelis.protelisDSL.Condition
import it.unibo.alchemist.language.protelis.protelisDSL.JavaConstructor

class ConditionGen extends ContentLessGen {
	
	private final CharSequence name
	private final CharSequence typeDesc
	
	public new(Condition cond, int pn, int rn, int cn, Map<String, String> varmap) {
		this(cond.type, pn, rn, cn, varmap)
	}
	
	public new(JavaConstructor cond, int pn, int rn, int cn, Map<String, String> varmap){
		super("condition")
		Objects.requireNonNull(cond)
		name = Utils.genCondName(pn,rn,cn)
		typeDesc = Utils.convertJavaConstructor(cond, varmap)
	}
	
	override getDescriptionLine() {
		'''name="«name»" «typeDesc»'''
	}
	
}