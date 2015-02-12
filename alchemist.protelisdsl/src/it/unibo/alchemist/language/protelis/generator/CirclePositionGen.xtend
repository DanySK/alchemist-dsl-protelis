/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import java.util.Random
import java.util.function.Consumer

class CirclePositionGen implements GroupPositionGenerator {
	
	private final Random r
	private final double x
	private final double y
	private final double rad
	private final int n;
	private int cur = 0;
	
	new(int nr, double xs, double ys, double rng, Random rand) {
		n = nr
		x = xs
		y = ys
		rad = rng
		r = rand
	}
	
	override hasNext() {
		cur < n
	}
	
	override next() {
		/*
		 * stepx = ix
		 */
		cur = cur+1;
		val angle = 2 * r.nextDouble * Math.PI
		val rnd = r.nextDouble;
		val radius = rad * Math.sqrt(rnd)
		#[x + radius * Math.cos(angle), y + radius * Math.sin(angle)]
	}
	
	override remove() {
	}
	
	override forEachRemaining(Consumer<? super double[]> arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}