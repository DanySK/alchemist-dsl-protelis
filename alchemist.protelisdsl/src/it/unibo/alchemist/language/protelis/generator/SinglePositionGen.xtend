/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import java.util.function.Consumer

class SinglePositionGen implements GroupPositionGenerator {
	
	final double x
	final double y
	boolean next = true
	
	new (double xp, double yp) {
		x = xp
		y = yp
	}
	
	override hasNext() {
		return next;
	}
	
	override next() {
		next = false;
		#[x, y]
	}
	
	override remove() {
	}
	
	override forEachRemaining(Consumer<? super double[]> arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	
}