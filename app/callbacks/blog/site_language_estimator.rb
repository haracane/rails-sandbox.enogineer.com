#app/callbacks/blog/site_language_estimator.rb
class Blog::SiteLanguageEstimator
  def initialize(attribute)
    @attribute = attribute
  end

  def before_save(record)
    return if record.send(@attribute)
    language = (/[ぁ-ゔ]/ =~ record.description ? :ja : '')
    record.send("#{@attribute}=", language)
  end
end
