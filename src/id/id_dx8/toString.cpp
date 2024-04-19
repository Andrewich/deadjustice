#include "StdAfx.h"
#include "toString.h"
#include "config.h"

//-----------------------------------------------------------------------------

const char*	toString( HRESULT hr )
{
	switch ( hr )
	{
	case DIERR_OLDDIRECTINPUTVERSION: return "DIERR_OLDDIRECTINPUTVERSION";
	case DIERR_BETADIRECTINPUTVERSION: return "DIERR_BETADIRECTINPUTVERSION";
	case DIERR_BADDRIVERVER: return "DIERR_BADDRIVERVER";
	case DIERR_DEVICENOTREG: return "DIERR_DEVICENOTREG";
	case DIERR_NOTFOUND: return "DIERR_NOTFOUND";
	case DIERR_INVALIDPARAM: return "DIERR_INVALIDPARAM";
	case DIERR_NOINTERFACE: return "DIERR_NOINTERFACE";
	case DIERR_GENERIC: return "DIERR_GENERIC";
	case DIERR_OUTOFMEMORY: return "DIERR_OUTOFMEMORY";
	case DIERR_UNSUPPORTED: return "DIERR_UNSUPPORTED";
	case DIERR_NOTINITIALIZED: return "DIERR_NOTINITIALIZED";
	case DIERR_ALREADYINITIALIZED: return "DIERR_ALREADYINITIALIZED";
	case DIERR_NOAGGREGATION: return "DIERR_NOAGGREGATION";
	case DIERR_OTHERAPPHASPRIO: return "DIERR_OTHERAPPHASPRIO";
	case DIERR_INPUTLOST: return "DIERR_INPUTLOST";
	case DIERR_ACQUIRED: return "DIERR_ACQUIRED";
	case DIERR_NOTACQUIRED: return "DIERR_NOTACQUIRED";
	case DIERR_INSUFFICIENTPRIVS: return "DIERR_INSUFFICIENTPRIVS";
	case DIERR_DEVICEFULL: return "DIERR_DEVICEFULL";
	case DIERR_MOREDATA: return "DIERR_MOREDATA";
	case DIERR_NOTDOWNLOADED: return "DIERR_NOTDOWNLOADED";
	case DIERR_HASEFFECTS: return "DIERR_HASEFFECTS";
	case DIERR_NOTEXCLUSIVEACQUIRED: return "DIERR_NOTEXCLUSIVEACQUIRED";
	case DIERR_INCOMPLETEEFFECT: return "DIERR_INCOMPLETEEFFECT";
	case DIERR_NOTBUFFERED: return "DIERR_NOTBUFFERED";
	case DIERR_EFFECTPLAYING: return "DIERR_EFFECTPLAYING";
	case DIERR_UNPLUGGED: return "DIERR_UNPLUGGED";
	case DIERR_REPORTFULL: return "DIERR_REPORTFULL";
	case DIERR_MAPFILEFAIL: return "DIERR_MAPFILEFAIL";
	default: return "DIERR_UNKNOWN";
	}
}
