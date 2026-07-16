module Jekyll
  class GitShaGenerator < Generator
    priority :highest

    def generate(site)
      sha = `git rev-parse HEAD`.strip
      sha = nil if sha.empty?

      site.config["git_sha"] = sha
      site.config["git_sha_short"] = sha && sha[0, 7]
    end
  end
end
