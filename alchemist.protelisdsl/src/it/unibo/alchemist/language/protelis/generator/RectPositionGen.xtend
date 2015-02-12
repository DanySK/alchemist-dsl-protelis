/*
 * Copyright (C) 2010-2015, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.protelis.generator

import java.util.Random
import java.util.function.Consumer

class RectPositionGen implements GroupPositionGenerator {
	
	private final Random r
	private final double x
	private final double y
	private final double w
	private final double h
	private final double ix
	private final double tx
	private final double iy
	private final double ty
	private final int nx
	private final int ny
	private final int n;
	private int cur = 0;
	
	new(int nr, double xs, double ys, double wd, double hd, String intervalx, String intervaly, String tolerancex, String tolerancey, Random rand) {
		n = nr
		x = xs
		y = ys
		w = wd
		h = hd
		r = rand
		if(intervalx == null) {
			ix = Double.NaN
			iy = Double.NaN
			tx = 0;
			ty = 0;
			nx = -1
			ny = -1
		} else {
			ix = Utils.pd(intervalx);
			iy = Utils.pd(intervaly);
			nx = (w / ix) as int + 1
			ny = (h / iy) as int + 1
			if(tolerancex == null) {
				tx = 0;
				ty = 0;
			} else {
				tx = Utils.pd(tolerancex)
				ty = Utils.pd(tolerancey)
			}
		}
	}
	
	override hasNext() {
		cur < n
	}
	
	override next() {
		/*
		 * stepx = ix
		 */
		val cr = cur
		cur = cur+1;
		if(Double.isNaN(ix)) {
			#[rnd(x, w), rnd(y, h)]
		} else {
			val cx = x + ix * (cr % nx);
			val cy = y + ((cr / nx) as int % ny )* iy ;
			#[rnd(cx-tx, tx), rnd(cy-ty, ty)]
		}
	}
	
	def private rnd(double s, double rng) {
		if(rng == 0) {
			s
		} else {
			s + r.nextDouble*rng
		}
	}
	
	override remove() {
	}
	
	override forEachRemaining(Consumer<? super double[]> arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	
}