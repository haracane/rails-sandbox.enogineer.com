#app/validators/blog/site_description_significance_validator.rb
class Blog::SiteDescriptionSignificanceValidator < ActiveModel::Validator
  def validate(record)
    description = record.description
    if description
      if /[ぁ-ゔ]/ =~ description
        return if description.length >= 10
      else
        return if description.split(/[\s,\.]+/).size >= 3
      end
    end
    record.errors.add :description, :not_significant
  end
end
