RSpec::Matchers.define :create_model do
  def for(n)
    @number = n
    self
  end

  def times
    @create_count = @number
    self
  end

  match do |model|
    klass = model.class
    name = klass.table_name.singularize

    @create_count ||= 1
    @created_count = 0

    before_count = klass.count

    @create_count.times { create(name) }

    @created_count = klass.count - before_count
    @created_count == @create_count
  end

  description { "create #{@create_count} #{'record'.pluralize(@create_count)}" }
  failure_message { "expected to #{description}, but created #{@created_count}" }
end

RSpec::Matchers.define :have_unique_constraint_on do |*fields|
  match do |model|
    name = model.class.table_name.singularize
    record = create(name)
    other_record = build(name)

    fields.each do |field|
      other_record.send("#{field}=", record.send(field))
    end

    begin
      other_record.save!(validate: false)
      false
    rescue ActiveRecord::RecordNotUnique
      true
    end
  end

  description { "have UNIQUE constraint on #{fields.join(', ')}" }
  failure_message { "expected to have UNIQUE constraint on #{fields.join(', ')}, but not" }
end

RSpec::Matchers.define :have_not_null_constraint_on do |field|
  match do |model|
    model.send("#{field}=", nil)
    begin
      model.save!(validate: false)
      false
    rescue ActiveRecord::StatementInvalid
      true
    end
  end

  description { "have NOT NULL constraint on #{field}" }
  failure_message { "expected to have NOT NULL constraint on #{field}, but not" }
end

RSpec::Matchers.define :have_foreign_key_constraint_on do |field|
  match do |model|
    model.send("#{field}=", 0)
    begin
      model.save!(validate: false)
      false
    rescue ActiveRecord::InvalidForeignKey
      true
    end
  end

  description { "have FOREIGN KEY constraint on #{field}" }
  failure_message { "expected to have FOREIGN KEY constraint on #{field}, but not" }
end

RSpec::Matchers.define :validate_timeliness_of do |field|
  def before(other_field)
    @conditions = [:before]
    @other_field = other_field
    self
  end

  def on(other_field)
    @conditions = [:on]
    @other_field = other_field
    self
  end

  def after(other_field)
    @conditions = [:after]
    @other_field = other_field
    self
  end

  def on_or_before(other_field)
    @conditions = [:on, :before]
    @other_field = other_field
    self
  end

  def on_or_after(other_field)
    @conditions = [:on, :after]
    @other_field = other_field
    self
  end

  def with_type_of(type)
    @type = type
    self
  end

  match do |model|
    earlier_time = Time.now
    earlier_time -= (earlier_time.day - 1) * 86400
    earlier_time -= earlier_time.sec

    later_time = earlier_time.clone
    later_time += 86400 + 1

    [:before, :on, :after].each do |condition|
      case condition
      when :before
        model.send("#{field}=", earlier_time)
        model.send("#{@other_field}=", later_time)
      when :on
        model.send("#{field}=", earlier_time)
        model.send("#{@other_field}=", earlier_time)
      when :after
        model.send("#{field}=", later_time)
        model.send("#{@other_field}=", earlier_time)
      end

      valid_condition = @conditions.include?(condition)

      begin
        model.save!
        return false unless valid_condition
      rescue ActiveRecord::RecordInvalid
        return false if valid_condition
      end
    end
    true
  end

  description { "ensure #{field} is #{@conditions.join(' or ')} #{@other_field}" }
  failure_message { "expected to ensure #{field} is #{@conditions.join(' or ')} #{@other_field}, but not" }
end

# validate_uniqueness_ofを利用すると外部キー制約がある場合に
# ActiveRecord::InvalidForeignKeyを投げるのでカスタムマッチャを用意
RSpec::Matchers.define :safely_validate_uniqueness_of do |*fields|
  match do |model|
    name = model.class.table_name.singularize
    record = create(name)
    other_record = build(name)

    fields.each do |field|
      other_record.send("#{field}=", record.send(field))
    end

    begin
      other_record.save!
      false
    rescue ActiveRecord::RecordInvalid
      true
    end
  end

  description { "require unique value for #{fields.join(', ')}" }
  failure_message { "expected to require unique value for #{fields.join(', ')}, but not" }
end

RSpec::Matchers.define :validate_objects_length_of do |field|
  def is_at_most(size)
    @max_size = size
    self
  end

  def is_equal_to(size)
    @equal_size = size
    self
  end

  def with_association(association)
    @association_name = association
    self
  end

  def with_factory(*args)
    @factory_args = args
    self
  end

  def with_message(message)
    @message = message
    self
  end

  match do |model|
    model_factory_name = model.class.table_name.singularize
    factory_args = @factory_args
    association_name = @association_name || field

    if factory_args.nil?
      association =
        model.
        class.
        reflect_on_all_associations(:has_many).
        find { |i_association| i_association.name == association_name }

      if association.nil?
        @failure_appendix = "(#{association_name.inspect} has-many association does not exist)"
        return false
      end

      factory_args = [association.table_name.singularize]
    end

    record = create(model_factory_name)

    if @max_size
      ((record.send(association_name).size)..@max_size).each do |size|
        unless record.valid?
          @failure_appendix = "(invalid with #{size} #{'object'.pluralize(size)})"
          return false
        end
        record.send(association_name) << build(*factory_args)
      end

      if record.valid?
        size = @max_size + 1
        @failure_appendix = "(valid with #{size} #{'object'.pluralize(size)})"
        return false
      end
    end

    if @equal_size
      ((record.send(association_name).size)...@equal_size).each do |size|
        if record.valid?
          @failure_appendix = "(valid with #{size} #{'object'.pluralize(size)})"
          return false
        end
        record.send(association_name) << build(*factory_args)
      end

      unless record.valid?
        @failure_appendix = "(valid with #{@equal_size} #{'object'.pluralize(@equal_size)})"
        return false
      end

      record.send(association_name) << build(*factory_args)

      if record.valid?
        size = @equal_size + 1
        @failure_appendix = "(valid with #{size} #{'object'.pluralize(size)})"
        return false
      end
    end

    if @message
      if record.errors.full_messages != [@message]
        @failure_appendix = "(with message #{record.errors.full_messages.inspect})"
        return false
      end
    end

    return true
  end

  description do
    description_prefix = "validate #{field} has a length of"
    conditions = []
    conditions << "at most #{@max_size}" if @max_size
    conditions << "equal to #{@equal_size}" if @equal_size
    conditions << "with association #{@association_name.inspect}" if @association_name
    conditions << "with FactoryGirl args (#{@factory_args.inspect})" if @factory_args
    conditions << "with message #{@message.inspect}" if @message
    "#{description_prefix} #{conditions.join(', ')}"
  end

  failure_message { "expected to #{description}, but not#{@failure_appendix}" }
end

RSpec::Matchers.define :have_breadcrumbs do |expected|
  match do
    breadcrumbs = page.find('.breadcrumbs')
    links = breadcrumbs.all('a').map(&:native).map { |a| [a.text, a['href']] }
    tail = breadcrumbs.find('li > span')
    links << [tail.text]

    links == expected
  end

  description { "have breadcrumbs #{expected.inspect}" }
  failure_message { "expected to have #{expected.inspect}, but got #{links.inspect}" }
end

RSpec::Matchers.define :have_meta do |name, options|
  options ||= {}

  match do
    nodes = page.all("meta[name=\"#{name}\"]", visible: false)
    return false if nodes.empty?
    return true if options.empty?

    @contents = nodes.map { |node| node.native['content'] }

    @contents.each do |content|
      return true if options[:text].present? && /#{options[:text]}/ =~ content
    end
    false
  end

  if options[:text]
    description { "have meta #{name} /#{options[:text]}/" }
    failure_message { "expected to have meta #{name} /#{options[:text]}/ in #{@contents.inspect}, but not" }
  else
    description { "have meta #{name}" }
    failure_message { "expected to have meta #{name}, but not" }
  end
end
