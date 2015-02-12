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
import java.util.Random
import it.unibo.alchemist.language.protelis.protelisDSL.ProtelisDSLFactory
import it.unibo.alchemist.language.protelis.protelisDSL.Arg
import it.unibo.alchemist.language.protelis.protelisDSL.Prog

class ProtoProgramGen implements XMLGenerator {
	
	private static final CharSequence DEFAULT = "Event"
	private static final CharSequence DEFAULT_SEND = "ChemicalReaction"
	private static final CharSequence DEFAULT_TIMEDIST = "DiracComb"
	private static final CharSequence DEFAULT_TIMEDIST_SEND = "ExponentialTime"
	public static final double DEFAULT_START_DRIFT_FACTOR = 0.1
	private static final ProtelisDSLFactory FACTORY = ProtelisDSLFactory.eINSTANCE
	private static final Arg ENV = genArg("ENV")
	private static final Arg NODE = genArg("NODE")
	private static final Arg REACTION = genArg("REACTION")
	
	private final ConditionGen cond
	private final ActionGen progact
	private final ActionGen sendact
	private final CharSequence name
	private final CharSequence actname
	private final CharSequence timedist
	private final CharSequence timedistsend
	private final CharSequence typeDesc
	private final CharSequence typeDescSend
	private final Random rnd = new Random(0)
	private CharSequence xml
	private CharSequence xml2
	private boolean defdist
	private double rate
	
	public new(Prog prog, String progString, int pn, Map<String, String> varmap) {
		val p = prog.program
		Objects.requireNonNull(p)
		name = '''protoprogram_p«pn»'''
		if(prog.timeDistribution == null) {
			rate = Utils.pdn(prog.rate, varmap)
			timedist = '''type="«DEFAULT_TIMEDIST»" p0="TOGENERATE" p1="«rate»"'''
			defdist = true
		} else {
			timedist = Utils.convertJavaConstructor(prog.timeDistribution, varmap)
			defdist = false
		}
		if(prog.timeDistributionSend == null) {
			timedistsend = '''type="«DEFAULT_TIMEDIST_SEND»" p0="«IF prog.rateSend == null »Infinity«ELSE»«Utils.pdn(prog.rateSend, varmap)»«ENDIF»" p1="RANDOM"'''
		} else {
			timedistsend = Utils.convertJavaConstructor(prog.timeDistributionSend, varmap)
		}
		
		typeDesc = '''type="«DEFAULT»" p0="NODE" p1="TIMEDIST"'''
		typeDescSend = '''type="«DEFAULT_SEND»" p0="NODE" p1="TIMEDIST"'''
		
		val jcp = FACTORY.createJavaConstructor
		jcp.javaClass = "ProtelisProgram"
		jcp.javaArgList = FACTORY.createArgList
		jcp.javaArgList.args.add(ENV);
		jcp.javaArgList.args.add(NODE);
		jcp.javaArgList.args.add(REACTION);
		jcp.javaArgList.args.add(genArg(progString));
		progact = new ActionGen(jcp, pn, 0, 0, varmap);
		actname = Utils.genActName(pn,0,0)
		
		val jcsa = FACTORY.createJavaConstructor
		jcsa.javaClass = "SendToNeighbor"
		jcsa.javaArgList = FACTORY.createArgList
		jcsa.javaArgList.args.add(NODE);
		jcsa.javaArgList.args.add(genArg(actname.toString));
		sendact = new ActionGen(jcsa, pn, 1, 0, varmap);
		
		jcsa.javaClass = "ComputationalRoundComplete"
		cond = new ConditionGen(jcsa, pn, 1, 0, varmap);
		
	}
	
	def private static genArg(String s) {
		val res = FACTORY.createArg
		res.^val = s
		res
	}
	
	override generateXML(int i) {
		if (xml == null) {
			xml = 
'''«Utils.indent(i)»<timedistribution name="time_«name»" «timedist»'''
			xml2 = '''></timedistribution>
«Utils.indent(i)»<reaction name="«name»" «typeDesc»>
«progact.generateXML(i+1)»
«Utils.indent(i)»</reaction>
«Utils.indent(i)»<timedistribution name="time_«name + "_send"»" «timedistsend»></timedistribution>
«Utils.indent(i)»<reaction name="«name + "_send"»" «typeDescSend»>
«cond.generateXML(i+1)»
«sendact.generateXML(i+1)»
«Utils.indent(i)»</reaction>
'''
		}
		if(defdist) {
			return '''«xml.toString.replace("TOGENERATE", Double.toString(rnd.nextDouble * rate * DEFAULT_START_DRIFT_FACTOR))»«xml2»'''
		}
		return '''«xml»«xml2»'''
	}
	
}
	
