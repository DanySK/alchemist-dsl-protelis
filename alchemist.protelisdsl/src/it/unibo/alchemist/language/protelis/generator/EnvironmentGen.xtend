/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.concurrent.ConcurrentHashMap
import java.util.Iterator
import java.util.Random
import it.unibo.alchemist.language.protelis.protelisDSL.Environment
import it.unibo.alchemist.language.protelis.protelisDSL.Prog

class EnvironmentGen implements XMLGenerator {

	private final String name;
	private final CharSequence typeAndParams;
	private final LinkingRuleGen lr;
	private final PositionGen pos;
	private final RandomEngineGen rand;
	private final CharSequence timetype;
	private final List<NodeGen> nodes = new ArrayList;
	private final List<MoleculeGen> molecules = new ArrayList;

	new(Environment env, List<String> programs) {
		val varmap = new ConcurrentHashMap
		if(env.constants != null) {
			env.constants.forEach[
				var String v
				if( it.VString == null ) {
					v = Double.toString(it.v)
				} else {
					v = it.VString
				}
				varmap.put(it.name, v)
			]
		}
		if (env.name == null) {
			name = "environment"
		} else {
			name = '''«env.name»'''
		}
		typeAndParams = Utils.checkDefault(env.type, "Continuous2DEnvironment", varmap)
		lr = new LinkingRuleGen(env.linkingRule, varmap)
		pos = new PositionGen(env.position)
		if (env.time != null) {
			timetype = Utils.checkDefault(env.time.type, "DoubleTime")
		} else {
			timetype = "DoubleTime"
		}
		rand = new RandomEngineGen(env.random)
		env.constrains.forEach[
			it.contents.forEach[
				molecules.add(new MoleculeGen(it))
			]
		]
		val prMap = new ConcurrentHashMap
		var prIndex = 0;
		for(Prog p: env.programs.filter[it.program != null]) {
			prMap.put(p, programs.get(prIndex++))
		}
		val pools = new HashMap<CharSequence, List<XMLGenerator>>
		env.programs.forEach [ pr, prn |
			val list = new ArrayList
			pools.put(pr.name, list)
			if(pr.program == null && pr.programlink == null) {
				pr.reactions.forEach [ re, ren |
					val reaction = new ReactionGen(re, prn, ren, varmap)
					list.add(reaction)
					re.conditions.forEach [ cnd, cndn |
						reaction.addCondition(new ConditionGen(cnd, prn, ren, cndn, varmap))
					]
					re.actions.forEach [ act, actn |
						reaction.addAction(new ActionGen(act, prn, ren, actn, varmap))
					]
				]
			} else if(pr.program != null) {
				list.add(new ProtoProgramGen(pr, prMap.get(pr), prn, varmap))
			}
		]
		val rngSeed = env.internalRNGSeed;
		env.constrains.forEach [ cstr, cnti |
			cstr.contents.forEach [ elem, eln |
				molecules.add(new MoleculeGen(elem))
			]
		]
		env.elements.forEach[ group, gn |
			var Iterator<double[]> posGen;
			if (group.gtype.equals("single")) {
				posGen = new SinglePositionGen(Utils.pdn(group.x, varmap), Utils.pdn(group.y, varmap))
			} else if (group.gtype.equals("rect")) {
				posGen = new RectPositionGen(group.numNodes, Utils.pdn(group.x, varmap), Utils.pdn(group.y, varmap), Utils.pdn(group.w, varmap),
					Utils.pdn(group.h, varmap), Utils.extractNumber(group.ix, varmap), Utils.extractNumber(group.iy, varmap), Utils.extractNumber(group.tx, varmap), Utils.extractNumber(group.ty, varmap), new Random(rngSeed))
			} else if(group.gtype.equals("circle")) {
				posGen = new CirclePositionGen(group.numNodes, Utils.pdn(group.x, varmap), Utils.pdn(group.y, varmap), Utils.pdn(group.r, varmap), new Random(rngSeed))
			} else {
				throw new UnsupportedOperationException("Load of arbitrary shape must be implemented yet")
			}
			posGen.forEach [ posArray, i |
				val node = new NodeGen(gn, i, group, posArray, varmap)
				nodes.add(node)
				group.contents.forEach [ cstr, cnti |
					var cond = true;
					if (cstr.ctype.equals("rect")) {
						val x = Utils.pdn(cstr.x, varmap)
						val y = Utils.pdn(cstr.y, varmap)
						val w = Utils.pdn(cstr.w, varmap)
						val h = Utils.pdn(cstr.h, varmap)
						val px = posArray.get(0)
						val py = posArray.get(1)
						cond = withinBorders(px, x, w) && withinBorders(py, y, h)
					} else if (cstr.ctype.equals("point")) {
						val x = Utils.pdn(cstr.x, varmap)
						val y = Utils.pdn(cstr.y, varmap)
						cond = e(x, posArray.get(0)) && e(y, posArray.get(1))
					}
					if (cond) {
						cstr.contents.forEach [ elem, eln |
							if(elem.valNum != null) {
								node.addContent(elem.name, Utils.extractNumber(elem.valNum, varmap))
							} else if (elem.valString != null) {
								node.addContent(elem.name, elem.valString)
							} else {
								node.addContent(elem.name, Boolean.toString(elem.valBool))
							}
						]
					}
				]
				group.reactions.forEach [
					node.addProgram(pools.get(it.name))
				]
			]
		]
	}
	
	def private static withinBorders(double p, double i, double s){
		(p >= i && p <= i+s) || e(p,i) || e(p, i+s)
	}
	
	def private static e(double a, double b) {
		Utils.fuzzyEquals(a, b)
	}

	override generateXML(int indent) {
'''<?xml version="1.0" encoding="UTF-8"?>
<environment name="«name»" «typeAndParams»>
	<concentration type="Local"></concentration>
«pos.generateXML(1)»
«lr.generateXML(1)»
«rand.generateXML(1)»
«FOR mol : molecules»«mol.generateXML(1)»
«ENDFOR»
«FOR n : nodes»«n.generateXML(1)»
«ENDFOR»
</environment>'''
	}

}
