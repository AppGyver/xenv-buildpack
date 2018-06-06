class ConfigMerger
  attr_reader :result

  def self.call(old, new)
    new(old, new).result
  end

  def initialize(old, new)
    @old = old
    @new = new
    @result = {}

    @result = remove_removed_keys(
      merged_configs
    )

    print_changes
  end

  private
  def print_changes
    puts "Envs to be removed: " \
      "#{removed.length > 0 ? removed.join(', ') : 'None'}"
    puts "Envs to be changed: " \
      "#{changed.keys.length > 0 ? changed.keys.join(', ') : 'None'}"
    puts "Envs to be added: " \
      "#{added.length > 0 ? added.join(', ') : 'None'}"
  end

  def merged_configs
    @old.merge(@new)
  end

  def remove_removed_keys(config)
    removed.each do |key|
      config[key] = nil
    end

    config
  end

  def removed
    @old.keys - @new.keys
  end

  def added
    @new.keys - @old.keys
  end

  def changed
    (@new.keys & @old.keys).each_with_object({}) do |key, hsh|
      old_val = @old[key]
      new_val = @new[key]

      if new_val != old_val
        hsh[key] = {from: old_val, to: new_val}
      end
    end
  end
end
