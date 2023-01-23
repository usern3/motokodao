let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.7.6-20230120/package-set.dhall sha256:137da4727c4672d83973759f19c05b7cf7a8a8d59008c616b55f80a9db066de3
let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let
  -- This is where you can add your own packages to the package-set
  additions =
    [] : List Package

let
  {- This is where you can override existing packages in the package-set

     For example, if you wanted to use version `v2.0.0` of the foo library:
     let overrides = [
         { name = "foo"
         , version = "v2.0.0"
         , repo = "https://github.com/bar/foo"
         , dependencies = [] : List Text
         }
     ]
  -}
  overrides =
    [] : List Package

in  upstream # additions # overrides
