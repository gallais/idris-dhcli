module git

import System.Console.Interface

files : Argument
files = Multiple pure

gitAdd : Interface
gitAdd = MkInterface
         []
         (("p", Flag) :: [])
         (Just files)

string : Argument
string = Unique pure

gitCommit : Interface
gitCommit = MkInterface
            []
            (("a", Flag) :: ("-m", Option string) :: [])
            Nothing

git : Interface
git = MkInterface
      (("add", gitAdd) :: ("commit", gitCommit) :: [])
      (("version", Flag) :: [])
      Nothing
