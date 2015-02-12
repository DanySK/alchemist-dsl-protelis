/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import java.util.LinkedList
import java.util.List
import java.util.Map
import java.util.concurrent.ConcurrentHashMap
import it.unibo.alchemist.language.protelis.protelisDSL.NodeGroup

class NodeGen extends GenericGen {
	
	private final int n
	private final int g
	private final double[] p
	private final CharSequence type;
	private final StringBuilder position;
	private final Map<CharSequence, CharSequence> c = new ConcurrentHashMap
	private final List<XMLGenerator> r = new LinkedList
	
	new(int gn, int nr, NodeGroup group, double[] pos, Map<String, String> varmap) {
		super("node")
		n = nr
		g = gn
		p = pos
		if(type == null) {
			type = '''type="ProtelisNode"'''
		} else {
			type = Utils.convertJavaConstructor(group.type,varmap)
		}
		position = new StringBuilder("position=\"")
		position.append(p.get(0))
		p.forEach[coord, num |
			if(num != 0) {
				position.append(',')
				position.append(coord)
			}
		]
		position.append('"')
	}
	
	def addContent(CharSequence cont, CharSequence value) {
		c.put(cont, value)
	}
	
	def addProgram(List<XMLGenerator> prog) {
		if(prog != null) {
			r.addAll(prog)
		}
	}
	
	override getContent(int i) {
'''<content«FOR cont: c.entrySet» «cont.key»="«Utils.checkForSpecialCharacter(cont.value)»"«ENDFOR»></content>
«FOR rea: r»«rea.generateXML(i)»«ENDFOR»'''
	}
	
	override getDescriptionLine() {
		'''name="group_«g»_node_«n»" «type» «position»'''
	}
	
	final override hasContent() {
		true
	}
	
}