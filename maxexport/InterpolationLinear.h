#ifndef _ANIM_INTERPOLATIONLINEAR_H
#define _ANIM_INTERPOLATIONLINEAR_H


#include "Interpolation.h"


/** 
 * Linear interpolation. 
 * @author Jani Kajala (jani.kajala@helsinki.fi)
 */
class InterpolationLinear : 
	public Interpolation
{
public:
	/** 
	 * Interpolates key frames using linear interpolation. 
	 * @param key0prev The key before the active segment.
	 * @param key0 The first key of the active segment.
	 * @param key1 The second key of the active segment.
	 * @param key1next The key after the active segment.
	 * @param t Fraction [0,1) of the active segment to interpolate.
	 * @param tlength Length of the active segment.
	 * @param channels Number of channels in the data.
	 * @param value [out] Receives interpolated values.
	 */
	void interpolate( 
		const KeyFrame* key0prev, const KeyFrame* key0,
		const KeyFrame* key1, const KeyFrame* key1next,
		float t, float tlength, int channels, float* values ) const;
};


#endif // _ANIM_INTERPOLATIONLINEAR_H
