{### osdefs.inc ###}


{define HX_DOS}
{.define GO32V2}

{$ifdef HX_DOS}
  {$ifdef GO32V2}
    {$undef GO32V2}
  {$endif}
{$endif}

{$ifdef GO32V2}
  {$ifdef HX_DOS}
    {$undef HX_DOS}
  {$endif}
{$endif}

