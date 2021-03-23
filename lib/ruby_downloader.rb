# frozen_string_literal: true

class RubyDownloader
  attr_reader :release

  def initialize(release)
    raise ArgumentError unless release.is_a?(RubyVersion)
    @release = release
  end

  def self.download(release)
    new(release).tap(&:download)
  end

  def download
    setup_paths

    if already_fetched?
      puts "Found previously extracted download for " \
        "#{release.version}, skipping"
      return
    end

    fetch_ruby_archive
    prepare_environment
  end

  def rubies_download_path
    Rails.root.join "tmp", "rubies"
  end

  def download_path
    rubies_download_path.join File.basename(release.source_url.path)
  end

  def extracted_download_path
    if release.dev?
      rubies_download_path.join "ruby-master"
    else
      rubies_download_path.join File.basename(release.source_url.path, ".zip")
    end
  end

  private

  def fetch_ruby_archive
    file = File.new download_path, "wb"
    request = HTTP.get release.source_url.to_s

    while (chunk = request.readpartial)
      file.write chunk
    end

    file.close
  end

  def already_fetched?
    File.exist? extracted_download_path.join "README.md"
  end

  def prepare_environment
    system "unzip #{download_path} -d #{rubies_download_path} > #{File::NULL}"
    system "gem unpack --target #{extracted_download_path.join("gems")} #{extracted_download_path.join("gems/rbs-*.gem")}" if release.has_type_signitures?
  end

  def setup_paths
    FileUtils.mkdir(rubies_download_path)
  rescue Errno::EEXIST
  end
end
