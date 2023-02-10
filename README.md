# Trying pushstate routing with purescript

Co-driver because we're navigating? 

## Building
built using pnpm

In project root run `pnpm install`  then `pnpm run dev` for the development server

Note: typescript may complain about missing type declarations for the generated purescript files. 
A quick fix is to add a `//@ts-ignore` directive above the import of the main function 

The solution taken in this repoistory is to generate typescript declarations using [purescript-tsd](https://github.com/minoki/purescript-tsd-gen).
Unfortunately this project does not have an npm package therefore is not packaged with this repoistory and is not automated therefore the error will still appear when you build this repository
