{
  "id":"cgen",
  "description":"a project generator service",
  "version":"0.0.0",
  "cutil":{
    "run":"cmake/cgen_cutil_run.cmake",
    "onLoad":"cmake/cgen_cutil_onload.cmake",
    "exports":"cmake/**.cmake"
  },
  "cps":{
    "exports":["cmake/**.cmake"],
    "hooks":{
      "on_load":"cgen_cps_on_load"
    }
  }
}