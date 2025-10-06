This is a branch used for storing assets (images, videos, etc.) for the project.

It used to be possible to just upload videos/images inside PRs or Issues and just link to them but that is now no longer possible as those are hosted behind an expiration with JWT token so they can't be reliably used for linking to in documentation.

> [!NOTE]
> There is an action on this branch that runs on every push and checks that each file in the `videos` folder has a corresponding file (with same name except extension) in the `gifs` folder. If that is not the case, a gif is automatically generated. This is mostly used to put gifs in docstring directly as they are rendered fine within Pluto docs helper (videos are still preferred for documentation pages)
