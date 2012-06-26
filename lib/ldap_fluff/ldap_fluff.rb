# Copyright 2012 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
require 'net/ldap'

class LdapFluff

  attr_accessor :ldap

  def initialize(config={})
    config ||= LdapFluff::CONFIG.instance
    type = config.server_type
    if type.respond_to? :to_sym
      if type == :posix
        @ldap = Posix.new(config)
      elsif type == :active_directory
        @ldap = ActiveDirectory.new(config)
      else
        raise Exception, "Unsupported connection type. Supported types = :active_directory, :posix"
      end
    end
  end

  # return true if the user password combination
  # authenticates the user, otherwise false
  def authenticate?(uid, password)
    @ldap.bind? uid, password
  end

  # return a list[] of groups for a given uid
  def group_list(uid)
    @ldap.groups_for_uid(uid)
  end

  # return true if a user is in all of the groups
  # in grouplist
  def is_in_groups?(uid, grouplist)
    @ldap.is_in_groups(uid, grouplist, true)
  end

end
