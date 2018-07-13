# Copyright 2018 Google Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ----------------------------------------------------------------------------
#
#     ***     AUTO GENERATED CODE    ***    AUTO GENERATED CODE     ***
#
# ----------------------------------------------------------------------------
#
#     This file is automatically generated by Magic Modules and manual
#     changes will be clobbered when the file is regenerated.
#
#     Please read more about how to change this file in README.md and
#     CONTRIBUTING.md located at the root of this package.
#
# ----------------------------------------------------------------------------

module Google
  module Container
    module Data
      # A class to manage data for UpgradeOptions for node_pool.
      class NodePoolUpgraOptio
        include Comparable

        attr_reader :auto_upgrade_start_time
        attr_reader :description

        def to_json(_arg = nil)
          {
            'autoUpgradeStartTime' => auto_upgrade_start_time,
            'description' => description
          }.reject { |_k, v| v.nil? }.to_json
        end

        def to_s
          {
            auto_upgrade_start_time: auto_upgrade_start_time.to_s,
            description: description.to_s
          }.map { |k, v| "#{k}: #{v}" }.join(', ')
        end

        def ==(other)
          return false unless other.is_a? NodePoolUpgraOptio
          compare_fields(other).each do |compare|
            next if compare[:self].nil? || compare[:other].nil?
            return false if compare[:self] != compare[:other]
          end
          true
        end

        def <=>(other)
          return false unless other.is_a? NodePoolUpgraOptio
          compare_fields(other).each do |compare|
            next if compare[:self].nil? || compare[:other].nil?
            result = compare[:self] <=> compare[:other]
            return result unless result.zero?
          end
          0
        end

        def inspect
          to_json
        end

        private

        def compare_fields(other)
          [
            { self: auto_upgrade_start_time, other: other.auto_upgrade_start_time },
            { self: description, other: other.description }
          ]
        end
      end

      # Manages a NodePoolUpgraOptio nested object
      # Data is coming from the GCP API
      class NodePoolUpgraOptioApi < NodePoolUpgraOptio
        def initialize(args)
          @auto_upgrade_start_time =
            Google::Container::Property::Time.api_parse(args['autoUpgradeStartTime'])
          @description = Google::Container::Property::String.api_parse(args['description'])
        end
      end

      # Manages a NodePoolUpgraOptio nested object
      # Data is coming from the Chef catalog
      class NodePoolUpgraOptioCatalog < NodePoolUpgraOptio
        def initialize(args)
          @auto_upgrade_start_time =
            Google::Container::Property::Time.catalog_parse(args[:auto_upgrade_start_time])
          @description = Google::Container::Property::String.catalog_parse(args[:description])
        end
      end
    end

    module Property
      # A class to manage input to UpgradeOptions for node_pool.
      class NodePoolUpgraOptio
        def self.coerce
          ->(x) { ::Google::Container::Property::NodePoolUpgraOptio.catalog_parse(x) }
        end

        # Used for parsing Chef catalog
        def self.catalog_parse(value)
          return if value.nil?
          return value if value.is_a? Data::NodePoolUpgraOptio
          Data::NodePoolUpgraOptioCatalog.new(value)
        end

        # Used for parsing GCP API responses
        def self.api_parse(value)
          return if value.nil?
          return value if value.is_a? Data::NodePoolUpgraOptio
          Data::NodePoolUpgraOptioApi.new(value)
        end
      end
    end
  end
end
