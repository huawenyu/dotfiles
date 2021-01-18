# $Id: log4sh 574 2007-06-02 20:09:15Z sfsetse $
# vim:syntax=sh:sts=2
# vim:foldmethod=marker:foldmarker=/**,*/
#
#/**
# <?xml version="1.0" encoding="UTF-8"?>
# <s:shelldoc xmlns:s="http://www.forestent.com/2005/XSL/ShellDoc">
# <s:header>
# log4sh 1.4.2
#
# http://log4sh.sourceforge.net/
#
# written by Kate Ward &lt;kate.ward@forestent.com>
# released under the LGPL
#
# this module implements something like the log4j module from the Apache group
#
# notes:
# *) the default appender is a ConsoleAppender named stdout with a level
#    of ERROR and layout of SimpleLayout
# *) the appender levels are as follows (decreasing order of output):
#    TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF
# </s:header>
#*/

# shell flags for log4sh:
# u - treat unset variables as an error when performing parameter expansion
__LOG4SH_SHELL_FLAGS='u'

# save the current set of shell flags, and then set some for log4sh
__log4sh_oldShellFlags=$-
for _log4sh_shellFlag in `echo "${__LOG4SH_SHELL_FLAGS}" |sed 's/\(.\)/\1 /g'`
do
  set -${_log4sh_shellFlag}
done

#
# constants
#
__LOG4SH_VERSION='1.4.2'

__LOG4SH_TRUE=0
__LOG4SH_FALSE=1
__LOG4SH_ERROR=2
__LOG4SH_NULL='~'

__LOG4SH_APPENDER_FUNC_PREFIX='_log4sh_app_'
__LOG4SH_APPENDER_INCLUDE_EXT='.inc'

__LOG4SH_TYPE_CONSOLE='ConsoleAppender'
__LOG4SH_TYPE_DAILY_ROLLING_FILE='DailyRollingFileAppender'
__LOG4SH_TYPE_FILE='FileAppender'
__LOG4SH_TYPE_ROLLING_FILE='RollingFileAppender'
__LOG4SH_TYPE_ROLLING_FILE_MAX_BACKUP_INDEX=1
__LOG4SH_TYPE_ROLLING_FILE_MAX_FILE_SIZE=10485760
__LOG4SH_TYPE_SMTP='SMTPAppender'
__LOG4SH_TYPE_SYSLOG='SyslogAppender'
__LOG4SH_TYPE_SYSLOG_FACILITY_NAMES=' kern user mail daemon auth security syslog lpr news uucp cron authpriv ftp local0 local1 local2 local3 local4 local5 local6 local7 '
__LOG4SH_TYPE_SYSLOG_FACILITY='user'

__LOG4SH_LAYOUT_HTML='HTMLLayout'
__LOG4SH_LAYOUT_SIMPLE='SimpleLayout'
__LOG4SH_LAYOUT_PATTERN='PatternLayout'

__LOG4SH_LEVEL_TRACE=0
__LOG4SH_LEVEL_TRACE_STR='TRACE'
__LOG4SH_LEVEL_DEBUG=1
__LOG4SH_LEVEL_DEBUG_STR='DEBUG'
__LOG4SH_LEVEL_INFO=2
__LOG4SH_LEVEL_INFO_STR='INFO'
__LOG4SH_LEVEL_WARN=3
__LOG4SH_LEVEL_WARN_STR='WARN'
__LOG4SH_LEVEL_ERROR=4
__LOG4SH_LEVEL_ERROR_STR='ERROR'
__LOG4SH_LEVEL_FATAL=5
__LOG4SH_LEVEL_FATAL_STR='FATAL'
__LOG4SH_LEVEL_OFF=6
__LOG4SH_LEVEL_OFF_STR='OFF'
__LOG4SH_LEVEL_CLOSED=255
__LOG4SH_LEVEL_CLOSED_STR='CLOSED'

__LOG4SH_PATTERN_DEFAULT='%d %p - %m%n'
__LOG4SH_THREAD_DEFAULT='main'

#__LOG4SH_CONFIGURATION="${LOG4SH_CONFIGURATION:-log4sh.properties}"
__LOG4SH_CONFIGURATION="${LOG4SH_CONFIGURATION:-none}"
__LOG4SH_CONFIG_PREFIX="${LOG4SH_CONFIG_PREFIX:-log4sh}"
__LOG4SH_CONFIG_LOG4J_CP='org.apache.log4j'

# the following IFS is *supposed* to be on two lines!!
__LOG4SH_IFS_ARRAY="
"
__LOG4SH_IFS_DEFAULT=' '

__LOG4SH_SECONDS=`eval "expr \`date '+%H \* 3600 + %M \* 60 + %S'\`"`

# configure log4sh debugging. set the LOG4SH_INFO environment variable to any
# non-empty value to enable info output, LOG4SH_DEBUG enable debug output, or
# LOG4SH_TRACE to enable trace output. log4sh ERROR and above messages are
# always printed. to send the debug output to a file, set the LOG4SH_DEBUG_FILE
# with the filename you want debug output to be written to.
__LOG4SH_TRACE=${LOG4SH_TRACE:+'_log4sh_trace '}
__LOG4SH_TRACE=${__LOG4SH_TRACE:-':'}
[ -n "${LOG4SH_TRACE:-}" ] && LOG4SH_DEBUG=1
__LOG4SH_DEBUG=${LOG4SH_DEBUG:+'_log4sh_debug '}
__LOG4SH_DEBUG=${__LOG4SH_DEBUG:-':'}
[ -n "${LOG4SH_DEBUG:-}" ] && LOG4SH_INFO=1
__LOG4SH_INFO=${LOG4SH_INFO:+'_log4sh_info '}
__LOG4SH_INFO=${__LOG4SH_INFO:-':'}

# set the constants to readonly
for _log4sh_const in `set |grep "^__LOG4SH_" |cut -d= -f1`; do
  readonly ${_log4sh_const}
done
unset _log4sh_const

#
# internal variables
#

__log4sh_filename=`basename $0`
__log4sh_tmpDir=''
__log4sh_trapsFile=''

__log4sh_alternative_mail='mail'

__log4sh_threadName=${__LOG4SH_THREAD_DEFAULT}
__log4sh_threadStack=${__LOG4SH_THREAD_DEFAULT}

__log4sh_seconds=0
__log4sh_secondsLast=0
__log4sh_secondsWrap=0

# workarounds for various commands
__log4sh_wa_strictBehavior=${__LOG4SH_FALSE}
(
  # determine if the set builtin needs to be evaluated. if the string is parsed
  # into two separate strings (common in ksh), then set needs to be evaled.
  str='x{1,2}'
  set -- ${str}
  test ! "$1" = 'x1' -a ! "${2:-}" = 'x2'
)
__log4sh_wa_setNeedsEval=$?


#=============================================================================
# Log4sh
#

#-----------------------------------------------------------------------------
# internal debugging
#

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_log</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This is an internal debugging function. It should not be called.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_log</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_log()
{
  _ll__level=$1
  shift
  if [ -z "${LOG4SH_DEBUG_FILE:-}" ]; then
    echo "log4sh:${_ll__level} $@" >&2
  else
    echo "${_ll__level} $@" >>${LOG4SH_DEBUG_FILE}
  fi
  unset _ll__level
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_trace</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This is an internal debugging function. It should not be called.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_log</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_trace()
{
  _log4sh_log "${__LOG4SH_LEVEL_TRACE_STR}" "${BASH_LINENO:+(${BASH_LINENO}) }- $@";
 }

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_debug</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This is an internal debugging function. It should not be called.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_log</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_debug()
{
  _log4sh_log "${__LOG4SH_LEVEL_DEBUG_STR}" "${BASH_LINENO:+(${BASH_LINENO}) }- $@";
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_info</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This is an internal debugging function. It should not be called.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_log</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_info()
{
  _log4sh_log "${__LOG4SH_LEVEL_INFO_STR}" "${BASH_LINENO:+(${BASH_LINENO}) }- $@";
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_warn</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This is an internal debugging function. It should not be called.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_log</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_warn()
{
  echo "log4sh:${__LOG4SH_LEVEL_WARN_STR} $@" >&2
  [ -n "${LOG4SH_DEBUG_FILE:-}" ] \
    && _log4sh_log "${__LOG4SH_LEVEL_WARN_STR}" "$@"
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_error</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This is an internal debugging function. It should not be called.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_log</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_error()
{
  echo "log4sh:${__LOG4SH_LEVEL_ERROR_STR} $@" >&2
  [ -n "${LOG4SH_DEBUG_FILE:-}" ] \
    && _log4sh_log "${__LOG4SH_LEVEL_ERROR_STR}" "$@"
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_fatal</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This is an internal debugging function. It should not be called.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_log</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_fatal()
{
  echo "log4sh:${__LOG4SH_LEVEL_FATAL_STR} $@" >&2
  [ -n "${LOG4SH_DEBUG_FILE:-}" ] \
    && _log4sh_log "${__LOG4SH_LEVEL_FATAL_STR}" "$@"
}

#-----------------------------------------------------------------------------
# miscellaneous
#

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_mktempDir</function></funcdef>
#       <void />
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Creates a secure temporary directory within which temporary files can be
#     created. Honors the <code>TMPDIR</code> environment variable if it is
#     set.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>tmpDir=`_log4sh_mktempDir`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_mktempDir()
{
  _lmd_tmpPrefix='log4sh'

  # try the standard mktemp function
  ( exec mktemp -dqt ${_lmd_tmpPrefix}.XXXXXX 2>/dev/null ) && return

  # the standard mktemp didn't work. doing our own.
  if [ -n "${RANDOM:-}" ]; then
    # $RANDOM works
    _lmd_random=${RANDOM}${RANDOM}${RANDOM}$$
  elif [ -r '/dev/urandom' ]; then
    _lmd_random=`od -vAn -N4 -tu4 </dev/urandom |sed 's/^[^0-9]*//'`
  else
    # $RANDOM doesn't work
    _lmd_date=`date '+%Y%m%d%H%M%S'`
    _lmd_random=`expr ${_lmd_date} / $$`
    unset _lmd_date
  fi

  _lmd_tmpDir="${TMPDIR:-/tmp}/${_lmd_tmpPrefix}.${_lmd_random}"
  ( umask 077 && mkdir "${_lmd_tmpDir}" ) || {
    _log4sh_fatal 'could not create temporary directory! exiting'
    exit 1
  }

  ${__LOG4SH_DEBUG} "created temporary directory (${_lmd_tmpDir})"
  echo "${_lmd_tmpDir}"
  unset _lmd_random _lmd_tmpDir _lmd_tmpPrefix
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_updateSeconds</function></funcdef>
#       <void />
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Set the <code>__log4sh_seconds</code> variable to the number of seconds
#     elapsed since the start of the script.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_updateSeconds`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_updateSeconds()
{
  if [ -n "${SECONDS:-}" ]; then
    __log4sh_seconds=${SECONDS}
  else
    _lgs__date=`date '+%H \* 3600 + %M \* 60 + %S'`
    _lgs__seconds=`eval "expr ${_lgs__date} + ${__log4sh_secondsWrap} \* 86400"`
    if [ ${_lgs__seconds} -lt ${__log4sh_secondsLast} ]; then
      __log4sh_secondsWrap=`expr ${__log4sh_secondsWrap} + 1`
      _lgs__seconds=`expr ${_lgs_seconds} + 86400`
    fi
    __log4sh_seconds=`expr ${_lgs__seconds} - ${__LOG4SH_SECONDS}`
    __log4sh_secondsLast=${__log4sh_seconds}
    unset _lgs__date _lgs__seconds
  fi
}

#/**
# <s:function group="Log4sh" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>log4sh_enableStrictBehavior</function></funcdef>
#       <void />
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Enables strict log4j behavior.
#   </para>
#   <para><emphasis role="strong">Since:</emphasis> 1.3.7</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>log4sh_enableStrictBehavior</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
log4sh_enableStrictBehavior()
{
  __log4sh_wa_strictBehavior=${__LOG4SH_TRUE}
}

#/**
# <s:function group="Log4sh" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>log4sh_setAlternative</function></funcdef>
#       <paramdef>string <parameter>command</parameter></paramdef>
#       <paramdef>string <parameter>path</parameter></paramdef>
#       <paramdef>boolean <parameter>useRuntimePath</parameter> (optional)</paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Specifies an alternative path for a command.
#   </para>
#   <para><emphasis role="strong">Since:</emphasis> 1.3.7</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>log4sh_setAlternative nc /bin/nc</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
log4sh_setAlternative()
{
  if [ $# -lt 2 ]; then
    _log4sh_error 'log4sh_setAlternative(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  lsa_cmdName=$1
  lsa_cmdPath=$2
  lsa_useRuntimePath=${3:-}
  __log4sh_return=${__LOG4SH_TRUE}

  # check that the alternative command exists and is executable
  if [ \
    ! -x "${lsa_cmdPath}" \
    -a ${lsa_useRuntimePath:-${__LOG4SH_FALSE}} -eq ${__LOG4SH_FALSE} \
  ]; then
    # the alternative command is not executable
    _log4sh_error "log4sh_setAlternative(): ${lsa_cmdName}: command not found"
    __log4sh_return=${__LOG4SH_ERROR}
  fi

  # check for valid alternative
  if [ ${__log4sh_return} -eq ${__LOG4SH_TRUE} ]; then
    case ${lsa_cmdName} in
      mail) ;;
      nc)
        lsa_cmdVers=`${lsa_cmdPath} --version 2>&1 |head -1`
        if echo "${lsa_cmdVers}" |grep '^netcat' >/dev/null; then
          # GNU Netcat
          __log4sh_alternative_nc_opts='-c'
        else
          # older netcat (v1.10)
          if nc -q 0 2>&1 |grep '^no destination$' >/dev/null 2>&1; then
            # supports -q option
            __log4sh_alternative_nc_opts='-q 0'
          else
            # doesn't support the -q option
            __log4sh_alternative_nc_opts=''
          fi
        fi
        unset lsa_cmdVers
        ;;
      *)
        # the alternative is not valid
        _log4sh_error "unrecognized command alternative '${lsa_cmdName}'"
        __log4sh_return=${__LOG4SH_FALSE}
        ;;
    esac
  fi

  # set the alternative
  if [ ${__log4sh_return} -eq ${__LOG4SH_TRUE} ]; then
    eval __log4sh_alternative_${lsa_cmdName}="\${lsa_cmdPath}"
    ${__LOG4SH_DEBUG} "alternative '${lsa_cmdName}' command set to '${lsa_cmdPath}'"
  fi

  unset lsa_cmdName lsa_cmdPath
  return ${__log4sh_return}
}

#-----------------------------------------------------------------------------
# array handling
#
# note: arrays are '1' based
#

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <code>integer</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_findArrayElement</function></funcdef>
#       <paramdef>string[] <parameter>array</parameter></paramdef>
#       <paramdef>string <parameter>element</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Find the position of element in an array</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>
#       pos=`_log4sh_findArrayElement "$array" $element`
#     </funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_findArrayElement()
{
  __pos=`echo "$1" |awk '$0==e{print NR}' e="$2"`
  [ -n "${__pos}" ] && echo "${__pos}" || echo 0
  unset __pos
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_getArrayElement</function></funcdef>
#       <paramdef>string[] <parameter>array</parameter></paramdef>
#       <paramdef>integer <parameter>position</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Retrieve the element at the given position from an array</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>element=`_log4sh_getArrayElement "$array" $position`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_getArrayElement()
{
  [ -n "${FUNCNAME:-}" ] && ${__LOG4SH_TRACE} "${FUNCNAME}()${BASH_LINENO:+'(called from ${BASH_LINENO})'}"
  _lgae_array=$1
  _lgae_index=$2
  ${__LOG4SH_TRACE} "_lgae_array='${_lgae_array}' _lgae_index='${_lgae_index}'"

  _lgae_oldIFS=${IFS} IFS=${__LOG4SH_IFS_ARRAY}
  if [ ${__log4sh_wa_setNeedsEval} -eq 0 ]; then
    set -- junk ${_lgae_array}
  else
    eval "set -- junk \"${_lgae_array}\""
    _lgae_arraySize=$#

    if [ ${_lgae_arraySize} -le ${__log4shAppenderCount} ]; then
      # the evaled set *didn't* work; failing back to original set command and
      # disabling the work around. (pdksh)
      __log4sh_wa_setNeedsEval=${__LOG4SH_FALSE}
      set -- junk ${_lgae_array}
    fi
  fi
  IFS=${_lgae_oldIFS}

  shift ${_lgae_index}
  ${__LOG4SH_TRACE} "1='${1:-}' 2='${2:-}' 3='${3:-}' ..."
  echo "$1"

  unset _lgae_array _lgae_arraySize _lgae_index _lgae_oldIFS
  return ${__LOG4SH_TRUE}
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <code>integer</code>
# </entry>
# <entry align="left">
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_getArrayLength</function></funcdef>
#       <paramdef>string[] <parameter>array</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Get the length of an array</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>length=`_log4sh_getArrayLength "$array"`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_getArrayLength()
{
  _oldIFS=${IFS} IFS=${__LOG4SH_IFS_ARRAY}
  set -- $1
  IFS=${_oldIFS} unset _oldIFS
  echo $#
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <code>string[]</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_setArrayElement</function></funcdef>
#       <paramdef>string[] <parameter>array</parameter></paramdef>
#       <paramdef>integer <parameter>position</parameter></paramdef>
#       <paramdef>string <parameter>element</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Place an element at a given location in an array</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>newArray=`_log4sh_setArrayElement "$array" $position $element`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_setArrayElement()
{
  echo "$1" |awk '{if(NR==r){print e}else{print $0}}' r=$2 e="$3"
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_peekStack</function></funcdef>
#       <paramdef>string[] <parameter>array</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Return the topmost element on a stack without removing the
#   element.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>element=`_log4sh_peekStack "$array"`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_peekStack()
{
  echo "$@" |awk '{line=$0}END{print line}'
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <code>string[]</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_popStack</function></funcdef>
#       <paramdef>string[] <parameter>array</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Remove the top-most element from a stack. This command takes a
#   normal log4sh string array as input, but treats it as though it were a
#   stack.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>newArray=`_log4sh_popStack "$array"`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_popStack()
{
  _array=$1
  _length=`_log4sh_getArrayLength "${_array}"`
  echo "${_array}" |awk '{if(NR<r){print $0}}' r=${_length}
  unset _array _length
}

#/**
# <s:function group="Log4sh" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_pushStack</function></funcdef>
#       <paramdef>string[] <parameter>array</parameter></paramdef>
#       <paramdef>string <parameter>element</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Add a new element to the top of a stack. This command takes a normal
#   log4sh string array as input, but treats it as though it were a
#   stack.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>newArray=`_log4sh_pushStack "$array" $element`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_pushStack()
{
  echo "${1:+$1${__LOG4SH_IFS_ARRAY}}$2"
}

#=============================================================================
# Appender
#

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_activateOptions</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Activate an appender's configuration. This should be called after
#     reconfiguring an appender via code. It needs only to be called once
#     before any logging statements are called. This calling of this function
#     will be required in log4sh 1.4.x.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_activateAppender myAppender</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_activateOptions()
{
  _aao_appender=$1
  ${__LOG4SH_APPENDER_FUNC_PREFIX}${_aao_appender}_activateOptions
  unset _aao_appender
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_close</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Disable any further logging via an appender. Once closed, the
#   appender can be reopened by setting it to any logging Level (e.g.
#   INFO).</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_close myAppender</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_close()
{
  appender_setLevel $1 ${__LOG4SH_LEVEL_CLOSED_STR}
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <code>boolean</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_exists</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Checks for the existance of a named appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>exists=`appender_exists myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_exists()
{
  _ae_index=`_log4sh_findArrayElement "${__log4shAppenders}" $1`
  [ "${_ae_index}" -gt 0 ] \
    && _ae_return=${__LOG4SH_TRUE} \
    || _ae_return=${__LOG4SH_FALSE}
  unset _ae_index
  return ${_ae_return}
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_getLayout</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Gets the Layout of an Appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>type=`appender_getLayout myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_getLayout()
{
  _agl_index=`_log4sh_findArrayElement "${__log4shAppenders}" $1`
  _log4sh_getArrayElement "${__log4shAppenderLayouts}" ${_agl_index}
  unset _agl_index
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_setLayout</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>layout</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Sets the Layout of an Appender (e.g. PatternLayout)</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_setLayout myAppender PatternLayout</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_setLayout()
{
  _asl_appender=$1
  _asl_layout=$2

  case ${_asl_layout} in
    ${__LOG4SH_LAYOUT_HTML}|\
    ${__LOG4SH_CONFIG_LOG4J_CP}.${__LOG4SH_LAYOUT_HTML})
      _asl_layout=${__LOG4SH_LAYOUT_HTML}
      ;;

    ${__LOG4SH_LAYOUT_SIMPLE}|\
    ${__LOG4SH_CONFIG_LOG4J_CP}.${__LOG4SH_LAYOUT_SIMPLE})
      _asl_layout=${__LOG4SH_LAYOUT_SIMPLE}
      ;;

    ${__LOG4SH_LAYOUT_PATTERN}|\
    ${__LOG4SH_CONFIG_LOG4J_CP}.${__LOG4SH_LAYOUT_PATTERN})
      _asl_layout=${__LOG4SH_LAYOUT_PATTERN}
      ;;

    *)
      _log4sh_error "unknown layout: ${_asl_layout}"
      return ${__LOG4SH_FALSE}
      ;;
  esac

  _asl_index=`_log4sh_findArrayElement "${__log4shAppenders}" $1`
  __log4shAppenderLayouts=`_log4sh_setArrayElement \
      "${__log4shAppenderLayouts}" ${_asl_index} "${_asl_layout}"`

  # resource the appender
  _appender_cache ${_asl_appender}

  unset _asl_appender _asl_index _asl_layout
  return ${__LOG4SH_TRUE}
}

#/**
# <s:function group="Appender" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_appender_getLayoutByIndex</function></funcdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Gets the Layout of an Appender at the given array index</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>type=`_appender_getLayoutByIndex 3`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_appender_getLayoutByIndex()
{
  _log4sh_getArrayElement "${__log4shAppenderLayouts}" $1
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <code>string</code>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_getLevel</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Gets the current logging Level of an Appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>type=`appender_getLevel myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_getLevel()
{
  if [ $# -ne 1 ]; then
    _log4sh_error 'appender_getLevel(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  agl_appender=$1

  agl_index=`_log4sh_findArrayElement "${__log4shAppenders}" ${agl_appender}`
  # TODO: put check for valid index here
  agl_level=`_log4sh_getArrayElement \
      "${__log4shAppenderLevels}" ${agl_index}`
  __log4sh_return=$?

  echo "${agl_level}"

  unset agl_appender agl_index agl_level
  return ${__log4sh_return}
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/<code>boolean</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_setLevel</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Sets the Level of an Appender (e.g. INFO)</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_setLevel myAppender INFO</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_setLevel()
{
  asl_appender=$1
  asl_level=$2

  _index=`_log4sh_findArrayElement "${__log4shAppenders}" ${asl_appender}`
  __log4shAppenderLevels=`_log4sh_setArrayElement \
    "${__log4shAppenderLevels}" ${_index} "${asl_level}"`

  # resource the appender
  _appender_cache ${asl_appender}

  unset asl_appender asl_level _index
  return ${__LOG4SH_TRUE}
}

#/**
# <s:function group="Appender" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_appender_getLevelByIndex</function></funcdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Gets the current logging Level of an Appender at the given array
#   index</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>type=`_appender_getLevelByIndex 3`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_appender_getLevelByIndex()
{
  [ -n "${FUNCNAME:-}" ] && ${__LOG4SH_TRACE} "${FUNCNAME}()${BASH_LINENO:+'(called from ${BASH_LINENO})'}"
  _log4sh_getArrayElement "${__log4shAppenderLevels}" $1
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_getPattern</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Gets the Pattern of an Appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>pattern=`appender_getPattern myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_getPattern()
{
  _index=`_log4sh_findArrayElement "$__log4shAppenders" $1`
  _log4sh_getArrayElement "$__log4shAppenderPatterns" $_index
  unset _index
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/<code>boolean</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_setPattern</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>pattern</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Sets the Pattern of an Appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_setPattern myAppender '%d %p - %m%n'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_setPattern()
{
  asp_appender=$1
  asp_pattern=$2

  _index=`_log4sh_findArrayElement "${__log4shAppenders}" ${asp_appender}`
  __log4shAppenderPatterns=`_log4sh_setArrayElement \
    "${__log4shAppenderPatterns}" ${_index} "${asp_pattern}"`

  # resource the appender
  _appender_cache ${asp_appender}

  unset asp_appender asp_pattern _index
  return ${__LOG4SH_TRUE}
}

#/**
# <s:function group="Appender" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_appender_getPatternByIndex</function></funcdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Gets the Pattern of an Appender at the specified array index</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>pattern=`_appender_getPatternByIndex 3`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_appender_getPatternByIndex()
{
  _log4sh_getArrayElement "$__log4shAppenderPatterns" $1
}

#/**
# <s:function group="Appender" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_appender_parsePattern</function></funcdef>
#       <paramdef>string <parameter>pattern</parameter></paramdef>
#       <paramdef>string <parameter>priority</parameter></paramdef>
#       <paramdef>string <parameter>message</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Generate a logging message given a Pattern, priority, and message.
#   All dates will be represented as ISO 8601 dates (YYYY-MM-DD
#   HH:MM:SS).</para>
#   <para>Note: the '<code>%r</code>' character modifier does not work in the
#   Solaris <code>/bin/sh</code> shell</para>
#   <para>Example:
#     <blockquote>
#       <funcsynopsis>
#         <funcsynopsisinfo>_appender_parsePattern '%d %p - %m%n' INFO "message to log"</funcsynopsisinfo>
#       </funcsynopsis>
#     </blockquote>
#   </para>
# </entry>
# </s:function>
#*/
_appender_parsePattern()
{
  _pattern=$1
  _priority=$2
  _msg=$3

  _date=''
  _doEval=${__LOG4SH_FALSE}

  # determine if various commands must be run
  _oldIFS="${IFS}"; IFS='%'; set -- x${_pattern}; IFS="${_oldIFS}"
  if [ $# -gt 1 ]; then
    # run the date command??
    IFS='d'; set -- ${_pattern}x; IFS="${_oldIFS}"
    [ $# -gt 1 ] && _date=`date '+%Y-%m-%d %H:%M:%S'`

    # run the eval command?
    IFS='X'; set -- ${_pattern}x; IFS="${_oldIFS}"
    [ $# -gt 1 ] && _doEval=${__LOG4SH_TRUE}
  fi
  unset _oldIFS

  # escape any '\' and '&' chars in the message
  _msg=`echo "${_msg}" |sed 's/\\\\/\\\\\\\\/g;s/&/\\\\&/g'`

  # deal with any newlines in the message
  _msg=`echo "${_msg}" |tr '\n' ''`

  # parse the pattern
  _pattern=`echo "${_pattern}" |sed \
    -e 's/%c/shell/g' \
    -e 's/%d{[^}]*}/%d/g' -e "s/%d/${_date}/g" \
    -e "s/%F/${__log4sh_filename}/g" \
    -e 's/%L//g' \
    -e 's/%n//g' \
    -e "s/%-*[0-9]*p/${_priority}/g" \
    -e "s/%-*[0-9]*r/${__log4sh_seconds}/g" \
    -e "s/%t/${__log4sh_threadName}/g" \
    -e 's/%x//g' \
    -e 's/%X{/$\{/g' \
    -e 's/%%m/%%%m/g' -e 's/%%/%/g' \
    -e "s%m${_msg}" |tr '' '\n'`
  if [ ${_doEval} -eq ${__LOG4SH_FALSE} ]; then
    echo "${_pattern}"
  else
    eval "echo \"${_pattern}\""
  fi

  unset _date _doEval _msg _pattern _tag
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_getType</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Gets the Type of an Appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>type=`appender_getType myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_getType()
{
  _index=`_log4sh_findArrayElement "$__log4shAppenders" $1`
  _log4sh_getArrayElement "$__log4shAppenderTypes" $_index
  unset _index
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_getAppenderType</function></funcdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.1</emphasis></para>
#   <para>
#     Gets the Type of an Appender at the given array index
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>type=`appender_getAppenderType 3`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_getAppenderType()
{
  _appender_getTypeByIndex "$@"
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/<code>boolean</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_setType</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>type</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Sets the Type of an Appender (e.g. FileAppender)</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_setType myAppender FileAppender</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_setType()
{
  ast_appender=$1
  ast_type=$2

  # XXX need to verify types

  _index=`_log4sh_findArrayElement "${__log4shAppenders}" ${ast_appender}`
  __log4shAppenderTypes=`_log4sh_setArrayElement \
    "${__log4shAppenderTypes}" ${_index} "${ast_type}"`

  # resource the appender
  _appender_cache ${ast_appender}

  unset ast_appender ast_type _index
  return ${__LOG4SH_TRUE}
}

#/**
# <s:function group="Appender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_setAppenderType</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>type</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.1</emphasis></para>
#   <para>
#     Sets the Type of an Appender (e.g. FileAppender)
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_setAppenderType myAppender FileAppender</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_setAppenderType()
{
  appender_setType "$@"
}

#/**
# <s:function group="Appender" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_appender_getTypeByIndex</function></funcdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Gets the Type of an Appender at the given array index</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>type=`_appender_getTypeByIndex 3`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_appender_getTypeByIndex()
{
  _log4sh_getArrayElement "$__log4shAppenderTypes" $1
}

#/**
# <s:function group="Appender" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_appender_cache</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Dynamically creates an appender function in memory that will fully
#   instantiate itself when it is called.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_appender_cache myAppender</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_appender_cache()
{
  _ac__appender=$1

  _ac__inc="${__log4sh_tmpDir}/${_ac__appender}${__LOG4SH_APPENDER_INCLUDE_EXT}"

  cat >"${_ac__inc}" <<EOF
${__LOG4SH_APPENDER_FUNC_PREFIX}${_ac__appender}_activateOptions()
{
  [ -n "\${FUNCNAME:-}" ] && \${__LOG4SH_TRACE} "\${FUNCNAME}()\${BASH_LINENO:+'(called from \${BASH_LINENO})'}"
  _appender_activate ${_ac__appender}
}

${__LOG4SH_APPENDER_FUNC_PREFIX}${_ac__appender}_append() { :; }
EOF

  # source the new functions
  . "${_ac__inc}"

  # call the activateOptions function
  # XXX will be removed in log4sh-1.5.x
  appender_activateOptions ${_ac__appender}
}

#/**
# <s:function group="Appender" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_appender_activate</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Dynamically regenerates an appender function in memory that is fully
#     instantiated for a specific logging task.
#     </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_appender_activate myAppender</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_appender_activate()
{
  [ -n "${FUNCNAME:-}" ] && ${__LOG4SH_TRACE} "${FUNCNAME}()${BASH_LINENO:+'(called from ${BASH_LINENO})'}"
  ${__LOG4SH_TRACE} "_appender_activate($#)"
  _aa_appender=$1
  ${__LOG4SH_TRACE} "_aa_appender='${_aa_appender}'"

  _aa_index=`_log4sh_findArrayElement "${__log4shAppenders}" ${_aa_appender}`
  _aa_inc="${__log4sh_tmpDir}/${_aa_appender}${__LOG4SH_APPENDER_INCLUDE_EXT}"

  ### generate function for inclusion
  # TODO can we modularize this in the future?

  # send STDOUT to our include file
  exec 4>&1 >${_aa_inc}

  # header
  cat <<EOF
${__LOG4SH_APPENDER_FUNC_PREFIX}${_aa_appender}_append()
{
  [ -n "\${FUNCNAME:-}" ] && \${__LOG4SH_TRACE} "\${FUNCNAME}()\${BASH_LINENO:+'(called from \${BASH_LINENO})'}"
  _la_level=\$1
  _la_message=\$2
EOF

  # determine the 'layout'
  _aa_layout=`_appender_getLayoutByIndex ${_aa_index}`
  ${__LOG4SH_TRACE} "_aa_layout='${_aa_layout}'"
  case ${_aa_layout} in
    ${__LOG4SH_LAYOUT_SIMPLE}|\
    ${__LOG4SH_LAYOUT_HTML})
      ${__LOG4SH_DEBUG} 'using simple/html layout'
      echo "  _la_layout=\"\${_la_level} - \${_la_message}\""
      ;;

    ${__LOG4SH_LAYOUT_PATTERN})
      ${__LOG4SH_DEBUG} 'using pattern layout'
      _aa_pattern=`_appender_getPatternByIndex ${_aa_index}`
      echo "  _la_layout=\`_appender_parsePattern '${_aa_pattern}' \${_la_level} \"\${_la_message}\"\`"
      ;;
  esac

  # what appender 'type' do we have? TODO check not missing
  _aa_type=`_appender_getTypeByIndex ${_aa_index}`
  ${__LOG4SH_TRACE} "_aa_type='${_aa_type}'"
  case ${_aa_type} in
    ${__LOG4SH_TYPE_CONSOLE})
      echo "  echo \"\${_la_layout}\""
      ;;

    ${__LOG4SH_TYPE_FILE}|\
    ${__LOG4SH_TYPE_ROLLING_FILE}|\
    ${__LOG4SH_TYPE_DAILY_ROLLING_FILE})
      _aa_file=`_appender_file_getFileByIndex ${_aa_index}`
      ${__LOG4SH_TRACE} "_aa_file='${_aa_file}'"
      if [ "${_aa_file}" = 'STDERR' ]; then
        echo "  echo \"\${_la_layout}\" >&2"
      elif [ "${_aa_file}" != "${__LOG4SH_NULL}" ]; then
        # do rotation
        case ${_aa_type} in
          ${__LOG4SH_TYPE_ROLLING_FILE})
            # check whether the max file size has been exceeded
            _aa_rotIndex=`appender_file_getMaxBackupIndex ${_aa_appender}`
            _aa_rotSize=`appender_file_getMaxFileSize ${_aa_appender}`
            cat <<EOF
  _la_rotSize=${_aa_rotSize}
  _la_size=\`wc -c '${_aa_file}' |awk '{print \$1}'\`
  if [ \${_la_size} -ge \${_la_rotSize} ]; then
    if [ ${_aa_rotIndex} -gt 0 ]; then
      # rotate the appender file(s)
      _la_rotIndex=`expr ${_aa_rotIndex} - 1`
      _la_rotFile="${_aa_file}.\${_la_rotIndex}"
      [ -f "\${_la_rotFile}" ] && rm -f "\${_la_rotFile}"
      while [ \${_la_rotIndex} -gt 0 ]; do
        _la_rotFileLast="\${_la_rotFile}"
        _la_rotIndex=\`expr \${_la_rotIndex} - 1\`
        _la_rotFile="${_aa_file}.\${_la_rotIndex}"
        [ -f "\${_la_rotFile}" ] && mv -f "\${_la_rotFile}" "\${_la_rotFileLast}"
      done
      mv -f '${_aa_file}' "\${_la_rotFile}"
    else
      # keep no backups; truncate the file
      cp /dev/null "${_aa_file}"
    fi
    unset _la_rotFile _la_rotFileLast _la_rotIndex
  fi
  unset _la_rotSize _la_size
EOF
            ;;
          ${__LOG4SH_TYPE_DAILY_ROLLING_FILE})
            ;;
        esac
        echo "  echo \"\${_la_layout}\" >>'${_aa_file}'"
      else
        # the file "${__LOG4SH_NULL}" is closed?? Why did we get here, and why
        # did I care when I wrote this bit of code?
        :
      fi

      unset _aa_file
      ;;

    ${__LOG4SH_TYPE_SMTP})
      _aa_smtpTo=`appender_smtp_getTo ${_aa_appender}`
      _aa_smtpSubject=`appender_smtp_getSubject ${_aa_appender}`

      cat <<EOF
  echo "\${_la_layout}" |\\
      ${__log4sh_alternative_mail} -s "${_aa_smtpSubject}" ${_aa_smtpTo}
EOF
      ;;

    ${__LOG4SH_TYPE_SYSLOG})
      cat <<EOF
  case "\${_la_level}" in
    ${__LOG4SH_LEVEL_TRACE_STR}) _la_tag='debug' ;;  # no 'trace' equivalent
    ${__LOG4SH_LEVEL_DEBUG_STR}) _la_tag='debug' ;;
    ${__LOG4SH_LEVEL_INFO_STR}) _la_tag='info' ;;
    ${__LOG4SH_LEVEL_WARN_STR}) _la_tag='warning' ;;  # 'warn' is deprecated
    ${__LOG4SH_LEVEL_ERROR_STR}) _la_tag='err' ;;     # 'error' is deprecated
    ${__LOG4SH_LEVEL_FATAL_STR}) _la_tag='alert' ;;
  esac
EOF

      _aa_facilityName=`appender_syslog_getFacility ${_aa_appender}`
      _aa_syslogHost=`appender_syslog_getHost ${_aa_appender}`
      _aa_hostname=`hostname |sed 's/^\([^.]*\)\..*/\1/'`

      # are we logging to a remote host?
      if [ -z "${_aa_syslogHost}" ]; then
        # no -- use logger
        cat <<EOF
  ( exec logger -p "${_aa_facilityName}.\${_la_tag}" \
      -t "${__log4sh_filename}[$$]" "\${_la_layout}" 2>/dev/null )
  unset _la_tag
EOF
      else
        # yes -- use netcat
        if [ -n "${__log4sh_alternative_nc:-}" ]; then
          case ${_aa_facilityName} in
            kern) _aa_facilityCode=0 ;;            # 0<<3
            user) _aa_facilityCode=8 ;;            # 1<<3
            mail) _aa_facilityCode=16 ;;           # 2<<3
            daemon) _aa_facilityCode=24 ;;         # 3<<3
            auth|security) _aa_facilityCode=32 ;;  # 4<<3
            syslog) _aa_facilityCode=40 ;;         # 5<<3
            lpr) _aa_facilityCode=48 ;;            # 6<<3
            news) _aa_facilityCode=56 ;;           # 7<<3
            uucp) _aa_facilityCode=64 ;;           # 8<<3
            cron) _aa_facilityCode=72 ;;           # 9<<3
            authpriv) _aa_facilityCode=80 ;;       # 10<<3
            ftp) _aa_facilityCode=88 ;;            # 11<<3
            local0) _aa_facilityCode=128 ;;        # 16<<3
            local1) _aa_facilityCode=136 ;;        # 17<<3
            local2) _aa_facilityCode=144 ;;        # 18<<3
            local3) _aa_facilityCode=152 ;;        # 19<<3
            local4) _aa_facilityCode=160 ;;        # 20<<3
            local5) _aa_facilityCode=168 ;;        # 21<<3
            local6) _aa_facilityCode=176 ;;        # 22<<3
            local7) _aa_facilityCode=184 ;;        # 23<<3
          esac

          cat <<EOF
  case \${_la_tag} in
    alert) _la_priority=1 ;;
    err|error) _la_priority=3 ;;
    warning|warn) _la_priority=4 ;;
    info) _la_priority=6 ;;
    debug) _la_priority=7 ;;
  esac
  _la_priority=\`expr ${_aa_facilityCode} + \${_la_priority}\`
  _la_date=\`date "+%b %d %H:%M:%S"\`
  _la_hostname='${_aa_hostname}'

  _la_syslogMsg="<\${_la_priority}>\${_la_date} \${_la_hostname} \${_la_layout}"

  # do RFC 3164 cleanups
  _la_date=\`echo \"\${_la_date}\" |sed 's/ 0\([0-9]\) /  \1 /'\`
  _la_syslogMsg=\`echo "\${_la_syslogMsg}" |cut -b1-1024\`

  ( echo "\${_la_syslogMsg}" |\
      exec ${__log4sh_alternative_nc} ${__log4sh_alternative_nc_opts} -w 1 -u \
          ${_aa_syslogHost} 514 )
  unset _la_tag _la_priority _la_date _la_hostname _la_syslogMsg
EOF
          unset _aa_facilityCode _aa_syslogHost _aa_hostname
        else
          # no netcat alternative set; doing nothing
          :
        fi
      fi
      unset _aa_facilityName
      ;;

    *) _log4sh_error "unrecognized appender type (${_aa_type})" ;;
  esac

  # footer
  cat <<EOF
  unset _la_level _la_message _la_layout
}
EOF

  # override the activateOptions function as we don't need it anymore
  cat <<EOF
${__LOG4SH_APPENDER_FUNC_PREFIX}${_aa_appender}_activateOptions() { :; }
EOF

  # restore STDOUT
  exec 1>&4 4>&-

  # source the newly created function
  ${__LOG4SH_TRACE} 're-sourcing the newly created function'
  . "${_aa_inc}"

  unset _aa_appender _aa_inc _aa_layout _aa_pattern _aa_type
}

#-----------------------------------------------------------------------------
# FileAppender
#

#/**
# <s:function group="FileAppender" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_appender_file_getFileByIndex</function></funcdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Get the filename of a FileAppender at the given array index</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_appender_file_getFileByIndex 3</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_appender_file_getFileByIndex()
{
  _log4sh_getArrayElement "${__log4shAppender_file_files}" $1
}

#/**
# <s:function group="FileAppender" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_file_getFile</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Get the filename of a FileAppender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_file_getFile myAppender</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_file_getFile()
{
  _index=`_log4sh_findArrayElement "$__log4shAppenders" $1`
  _log4sh_getArrayElement "$__log4shAppender_file_files" $_index
  unset _index
}

#/**
# <s:function group="FileAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_file_setFile</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>filename</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Set the filename for a FileAppender (e.g. <filename>STDERR</filename> or
#     <filename>/var/log/log4sh.log</filename>).
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_file_setFile myAppender STDERR</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_file_setFile()
{
  afsf_appender=$1
  afsf_file=$2
  ${__LOG4SH_TRACE} "afsf_appender='${afsf_appender}' afsf_file='${afsf_file}'"

  if [ -n "${afsf_appender}" -a -n "${afsf_file}" ]; then
    # set the file
    _index=`_log4sh_findArrayElement "${__log4shAppenders}" ${afsf_appender}`
    __log4shAppender_file_files=`_log4sh_setArrayElement \
      "${__log4shAppender_file_files}" ${_index} "${afsf_file}"`
    _return=$?

    # create the file (if it isn't already)
    if [ ${_return} -eq ${__LOG4SH_TRUE} \
      -a ! "${afsf_file}" '=' "${__LOG4SH_NULL}" \
      -a ! "${afsf_file}" '=' 'STDERR' \
      -a ! -f "${afsf_file}" \
    ]; then
      touch "${afsf_file}" 2>/dev/null
      _result=$?
      # determine success of touch command
      if [ ${_result} -eq 1 ]; then
        _log4sh_error "appender_file_setFile(): could not create file (${afsf_file}); closing appender"
        appender_setLevel ${afsf_appender} ${__LOG4SH_LEVEL_CLOSED_STR}
      fi
      unset _result
    fi
  else
    _log4sh_error 'appender_file_setFile(): missing appender and/or file'
    _return=${__LOG4SH_FALSE}
  fi

  # resource the appender
  _appender_cache ${afsf_appender}

  unset afsf_appender afsf_file _index
  return ${_return}
}

#/**
# <s:function group="FileAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_setAppenderFile</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>filename</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.2</emphasis></para>
#   <para>
#     Set the filename for a FileAppender (e.g. "STDERR" or
#     "/var/log/log4sh.log")
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_setAppenderFile myAppender STDERR</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_setAppenderFile()
{
  appender_file_setFile "$@"
}

#/**
# <s:function group="FileAppender" modifier="public">
# <entry align="right">
#   <code>integer</code>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_file_getMaxBackupIndex</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Returns the value of the MaxBackupIndex option.
#   </para>
#   <para><emphasis role="strong">Since:</emphasis> 1.3.7</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_file_getMaxBackupIndex myAppender</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_file_getMaxBackupIndex()
{
  if [ $# -ne 1 ]; then
    _log4sh_error 'appender_file_getMaxBackupIndex(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  afgmbi_appender=$1

  afgmbi_index=`_log4sh_findArrayElement \
      "${__log4shAppenders}" ${afgmbi_appender}`
  # TODO: put check for valid index here
  _log4sh_getArrayElement \
      "${__log4shAppender_rollingFile_maxBackupIndexes}" ${afgmbi_index}
  __log4sh_return=$?

  unset afgmbi_appender afgmbi_index
  return ${__log4sh_return}
}

#/**
# <s:function group="FileAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_file_setMaxBackupIndex</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Set the maximum number of backup files to keep around.</para>
#   <para>
#     The <emphasis role="strong">MaxBackupIndex</emphasis> option determines
#     how many backup files are kept before the oldest is erased. This option
#     takes a positive integer value. If set to zero, then there will be no
#     backup files and the log file will be truncated when it reaches
#     <option>MaxFileSize</option>.
#   </para>
#   <para><emphasis role="strong">Since:</emphasis> 1.3.7</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_file_setMaxBackupIndex myAppender 3</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_file_setMaxBackupIndex()
{
  if [ $# -ne 2 ]; then
    _log4sh_error "appender_file_setMaxBackupIndex(): invalid number of parameters ($#)"
    return ${__LOG4SH_FALSE}
  fi

  afsmbi_appender=$1
  afsmbi_maxIndex=$2

  # TODO: put check for valid input

  afsmbi_index=`_log4sh_findArrayElement \
      "${__log4shAppenders}" ${afsmbi_appender}`
  # TODO: put check for valid index here
  __log4shAppender_rollingFile_maxBackupIndexes=`_log4sh_setArrayElement \
      "${__log4shAppender_rollingFile_maxBackupIndexes}" ${afsmbi_index} \
      "${afsmbi_maxIndex}"`
  __log4sh_return=$?

  # re-source the appender
  _appender_cache ${afsmbi_appender}

  unset afsmbi_appender afsmbi_maxIndex afsmbi_index
  return ${__log4sh_return}
}

#/**
# <s:function group="FileAppender" modifier="public">
# <entry align="right">
#   <code>integer</code>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_file_getMaxFileSize</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Get the maximum size that the output file is allowed to reach before
#     being rolled over to backup files.
#   </para>
#   <para><emphasis role="strong">Since:</emphasis> 1.3.7</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>maxSize=`appender_file_getMaxBackupSize myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_file_getMaxFileSize()
{
  if [ $# -ne 1 ]; then
    _log4sh_error "appender_file_getMaxFileSize(): invalid number of parameters ($#)"
    return ${__LOG4SH_FALSE}
  fi

  afgmfs_appender=$1

  afgmfs_index=`_log4sh_findArrayElement \
      "${__log4shAppenders}" ${afgmfs_appender}`
  # TODO: put check for valid index here
  _log4sh_getArrayElement \
      "${__log4shAppender_rollingFile_maxFileSizes}" ${afgmfs_index}
  __log4sh_return=$?

  unset afgmfs_appender afgmfs_index
  return ${__log4sh_return}
}

#/**
# <s:function group="FileAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_file_setMaxFileSize</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>size</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Set the maximum size that the output file is allowed to reach before
#     being rolled over to backup files.
#   </para>
#   <para>
#     In configuration files, the <option>MaxFileSize</option> option takes an
#     long integer in the range 0 - 2^40. You can specify the value with the
#     suffixes "KiB", "MiB" or "GiB" so that the integer is interpreted being
#     expressed respectively in kilobytes, megabytes or gigabytes. For example,
#     the value "10KiB" will be interpreted as 10240.
#   </para>
#   <para><emphasis role="strong">Since:</emphasis> 1.3.7</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_file_setMaxBackupSize myAppender 10KiB</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_file_setMaxFileSize()
{
  if [ $# -ne 2 ]; then
    _log4sh_error \
        "appender_file_setMaxFileSize(): invalid number of parameters ($#)"
    return ${__LOG4SH_ERROR}
  fi

  afsmfs_appender=$1
  afsmfs_size=$2
  afsmfs_return=${__LOG4SH_TRUE}

  # split the file size into parts
  afsmfs_value=`expr ${afsmfs_size} : '\([0-9]*\)'`
  afsmfs_unit=`expr ${afsmfs_size} : '[0-9]* *\([A-Za-z]\{1,3\}\)'`

  # determine multiplier
  if [ ${__log4sh_wa_strictBehavior} -eq ${__LOG4SH_TRUE} ]; then
    case "${afsmfs_unit}" in
      KB) afsmfs_unit='KiB' ;;
      MB) afsmfs_unit='MiB' ;;
      GB) afsmfs_unit='GiB' ;;
      TB) afsmfs_unit='TiB' ;;
    esac
  fi
  case "${afsmfs_unit}" in
    B) afsmfs_mul=1 ;;
    KB) afsmfs_mul=1000 ;;
    KiB) afsmfs_mul=1024 ;;
    MB) afsmfs_mul=1000000 ;;
    MiB) afsmfs_mul=1048576 ;;
    GB) afsmfs_mul=1000000000 ;;
    GiB) afsmfs_mul=1073741824 ;;
    TB) afsmfs_mul=1000000000000 ;;
    TiB) afsmfs_mul=1099511627776 ;;
    '')
      _log4sh_warn 'missing file size unit; assuming bytes'
      afsmfs_mul=1
      ;;
    *)
      _log4sh_error "unrecognized file size unit '${afsmfs_unit}'"
      afsmfs_return=${__LOG4SH_ERROR}
      ;;
  esac

  # calculate maximum file size
  if [ ${afsmfs_return} -eq ${__LOG4SH_TRUE} ]; then
    afsmfs_maxFileSize=`(expr ${afsmfs_value} \* ${afsmfs_mul} 2>&1)`
    if [ $? -gt 0 ]; then
      _log4sh_error "problem calculating maximum file size: '${afsmfs_maxFileSize}'"
      afsmfs_return=${__LOG4SH_FALSE}
    fi
  fi

  # store the maximum file size
  if [ ${afsmfs_return} -eq ${__LOG4SH_TRUE} ]; then
    afsmfs_index=`_log4sh_findArrayElement \
        "${__log4shAppenders}" ${afsmfs_appender}`
    # TODO: put check for valid index here
    __log4shAppender_rollingFile_maxFileSizes=`_log4sh_setArrayElement \
        "${__log4shAppender_rollingFile_maxFileSizes}" ${afsmfs_index} \
        "${afsmfs_maxFileSize}"`
  fi

  # re-source the appender
  [ ${afsmfs_return} -eq ${__LOG4SH_TRUE} ] \
      && _appender_cache ${afsmfs_appender}

  __log4sh_return=${afsmfs_return}
  unset afsmfs_appender afsmfs_size afsmfs_value afsmfs_unit afsmfs_mul \
      afsmfs_maxFileSize afsmfs_index afsmfs_return
  return ${__log4sh_return}
}

#-----------------------------------------------------------------------------
# SMTPAppender
#

#/**
# <s:function group="SMTPAppender" modifier="public">
# <entry align="right">
#   <code>string</code>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_smtp_getTo</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Get the to address for the given appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>email=`appender_smtp_getTo myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_smtp_getTo()
{
  if [ $# -ne 1 ]; then
    _log4sh_error 'appender_smtp_getTo(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  asgt_appender=$1

  asgt_index=`_log4sh_findArrayElement "${__log4shAppenders}" ${asgt_appender}`
  # TODO: put check for valid index here
  asgt_to=`_log4sh_getArrayElement \
      "${__log4shAppender_smtp_tos}" ${asgt_index}`
  __log4sh_return=$?

  [ "${asgt_to}" = "${__LOG4SH_NULL}" ] && asgt_to=''
  echo "${asgt_to}"

  unset asgt_appender asgt_index asgt_to
  return ${__log4sh_return}
}

#/**
# <s:function group="SMTPAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_smtp_setTo</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>email</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Set the to address for the given appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_smtp_setTo myAppender user@example.com</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_smtp_setTo()
{
  if [ $# -ne 2 ]; then
    _log4sh_error 'appender_smtp_setTo(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  asst_appender=$1
  asst_email=$2

  asst_index=`_log4sh_findArrayElement "${__log4shAppenders}" ${asst_appender}`
  # TODO: put check for valid index here
  __log4shAppender_smtp_tos=`_log4sh_setArrayElement \
    "${__log4shAppender_smtp_tos}" ${asst_index} "${asst_email}"`

  # resource the appender
  _appender_cache ${asst_appender}

  unset asst_appender asst_email asst_index
}

#/**
# <s:function group="SMTPAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_setAppenderRecipient</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>email</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.1</emphasis></para>
#   <para>
#     Set the to address for the given appender
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_smtp_setTo myAppender user@example.com</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_setAppenderRecipient()
{
  appender_smtp_setTo "$@"
}

#/**
# <s:function group="SMTPAppender" modifier="public">
# <entry align="right">
#   <code>string</code>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_smtp_getSubject</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Get the email subject for the given appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>subject=`appender_smtp_getSubject myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_smtp_getSubject()
{
  if [ $# -ne 1 ]; then
    _log4sh_error 'appender_smtp_getSubject(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  asgs_appender=$1

  asgs_index=`_log4sh_findArrayElement "${__log4shAppenders}" ${asgs_appender}`
  # TODO: put check for valid index here
  asgs_subject=`_log4sh_getArrayElement \
      "${__log4shAppender_smtp_subjects}" ${asgs_index}`
  __log4sh_return=$?

  [ "${asgs_subject}" = "${__LOG4SH_NULL}" ] && asgs_subject=''
  echo "${asgs_subject}"

  unset asgs_appender asgs_index asgs_subject
  return ${__log4sh_return}
}

#/**
# <s:function group="SMTPAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_smtp_setSubject</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>subject</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Sets the email subject for an SMTP appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_smtp_setSubject myAppender "This is a test"</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_smtp_setSubject()
{
  if [ $# -ne 2 ]; then
    _log4sh_error 'appender_smtp_setSubject(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  asss_appender=$1
  asss_subject=$2

  # set the Subject
  asss_index=`_log4sh_findArrayElement "${__log4shAppenders}" ${asss_appender}`
  if [ ${asss_index} -gt 0 ]; then
    __log4shAppender_smtp_subjects=`_log4sh_setArrayElement \
      "${__log4shAppender_smtp_subjects}" ${asss_index} "${asss_subject}"`
    __log4sh_return=${__LOG4SH_TRUE}
  else
    _log4sh_error "could not set Subject for appender (${asss_appender})"
    __log4sh_return=${__LOG4SH_FALSE}
  fi

  # re-source the appender
  _appender_cache ${asss_appender}

  unset asss_appender asss_subject asss_index
  return ${__log4sh_return}
}

#/**
# <s:function group="SMTPAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_setAppenderSubject</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>subject</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.1</emphasis></para>
#   <para>
#     Sets the email subject for an SMTP appender
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_setAppenderSubject myAppender "This is a test"</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_setAppenderSubject()
{
  appender_smtp_setSubject "$@"
}

#-----------------------------------------------------------------------------
# SyslogAppender
#

#/**
# <s:function group="SyslogAppender" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef>
#         <function>_appender_syslog_getFacilityByIndex</function>
#       </funcdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Get the syslog facility of the specified appender by index</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>
#       facility=`_appender_syslog_getFacilityByIndex 3`
#     </funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_appender_syslog_getFacilityByIndex()
{
  _log4sh_getArrayElement "$__log4shAppender_syslog_facilities" $1
}

#/**
# <s:function group="SyslogAppender" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_getSyslogFacility</function></funcdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.1</emphasis></para>
#   <para>
#     Get the syslog facility of the specified appender by index
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>facility=`appender_getSyslogFacility 3`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_getSyslogFacility()
{
  _appender_syslog_getFacilityByIndex "$@"
}

#/**
# <s:function group="SyslogAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_syslog_getFacility</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Get the syslog facility for the given appender.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>facility=`appender_syslog_getFacility myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_syslog_getFacility()
{
  if [ $# -ne 1 ]; then
    _log4sh_error 'appender_syslog_getFacility(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  asgf_appender=$1

  asgf_index=`_log4sh_findArrayElement "$__log4shAppenders" ${asgf_appender}`
  _log4sh_getArrayElement "${__log4shAppender_syslog_facilities}" ${asgf_index}

  unset asgf_appender asgf_index
}

#/**
# <s:function group="SyslogAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_syslog_setFacility</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>facility</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Set the syslog facility for the given appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_syslog_setFacility myAppender local4`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_syslog_setFacility()
{
  if [ $# -ne 2 ]; then
    _log4sh_error 'appender_syslog_setFacility(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi
  assf_appender=$1
  assf_facility=$2

  # check for valid facility
  echo "${__LOG4SH_TYPE_SYSLOG_FACILITY_NAMES}" |grep " ${assf_facility} " >/dev/null
  if [ $? -ne 0 ]; then
    # the facility is not valid
    _log4sh_error "[${assf_facility}] is an unknown syslog facility. Defaulting to [user]."
    assf_facility='user'
  fi

  # set appender facility
  assf_index=`_log4sh_findArrayElement "${__log4shAppenders}" ${assf_appender}`
  # TODO: put check for valid index here
  __log4shAppender_syslog_facilities=`_log4sh_setArrayElement \
    "${__log4shAppender_syslog_facilities}" ${assf_index} "${assf_facility}"`

  # re-source the appender
  _appender_cache ${assf_appender}

  unset assf_appender assf_facility assf_index
  return ${__LOG4SH_TRUE}
}

#/**
# <s:function group="SyslogAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_setSyslogFacility</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>facility</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.2</emphasis></para>
#   <para>
#     Set the syslog facility for the given appender
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_setSyslogFacility myAppender local4`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_setSyslogFacility()
{
  appender_syslog_setFacility "$@"
}

#/**
# <s:function group="SyslogAppender" modifier="public">
# <entry align="right">
#   <code>string</code>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_syslog_getHost</function></funcdef>
#       <paramdef>integer <parameter>index</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Get the syslog host of the specified appender.
#   </para>
#   <para><emphasis role="strong">Since:</emphasis> 1.3.7</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>host=`appender_syslog_getHost myAppender`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
appender_syslog_getHost()
{
  if [ $# -ne 1 ]; then
    _log4sh_error 'appender_syslog_getHost(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  asgh_appender=$1

  asgh_index=`_log4sh_findArrayElement "${__log4shAppenders}" ${asgh_appender}`
  # TODO: put check for valid index here
  asgh_host=`_log4sh_getArrayElement \
      "${__log4shAppender_syslog_hosts}" ${asgh_index}`
  __log4sh_return=$?

  [ "${asgh_host}" = "${__LOG4SH_NULL}" ] && asgh_host=''
  echo "${asgh_host}"

  unset asgh_appender asgh_index asgh_host
  return ${__log4sh_return}
}

#/**
# <s:function group="SyslogAppender" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>appender_syslog_setHost</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>host</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Set the syslog host for the given appender. Requires that the 'nc'
#     command alternative has been previously set with the
#     log4sh_setAlternative() function.
#   </para>
#   <para><emphasis role="strong">Since:</emphasis> 1.3.7</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>appender_syslog_setHost myAppender localhost</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
#
# The BSD syslog Protocol
#   http://www.ietf.org/rfc/rfc3164.txt
#
appender_syslog_setHost()
{
  if [ $# -ne 2 ]; then
    _log4sh_error 'appender_syslog_setHost(): invalid number of parameters'
    return ${__LOG4SH_FALSE}
  fi

  assh_appender=$1
  assh_host=$2

  [ -z "${__log4sh_alternative_nc:-}" ] \
      && _log4sh_warn 'the nc (netcat) command alternative is required for remote syslog logging. see log4sh_setAlternative().'

  assh_index=`_log4sh_findArrayElement "${__log4shAppenders}" ${assh_appender}`
  # TODO: put check for valid index here
  __log4shAppender_syslog_hosts=`_log4sh_setArrayElement \
      "${__log4shAppender_syslog_hosts}" ${assh_index} "${assh_host}"`

  # re-source the appender
  _appender_cache ${assh_appender}

  unset assh_appender assh_host assh_index
  return ${__LOG4SH_TRUE}
}

#=============================================================================
# Level
#

#/**
# <s:function group="Level" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_level_toLevel</function></funcdef>
#       <paramdef>integer <parameter>val</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Converts an internally used level integer into its external level
#   equivalent</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>level=`logger_level_toLevel 3`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
# TODO use arrays instead of case statement ??
logger_level_toLevel()
{
  _ltl__val=$1

  _ltl__return=${__LOG4SH_TRUE}
  _ltl__level=''

  case ${_ltl__val} in
    ${__LOG4SH_LEVEL_TRACE}) _ltl__level=${__LOG4SH_LEVEL_TRACE_STR} ;;
    ${__LOG4SH_LEVEL_DEBUG}) _ltl__level=${__LOG4SH_LEVEL_DEBUG_STR} ;;
    ${__LOG4SH_LEVEL_INFO}) _ltl__level=${__LOG4SH_LEVEL_INFO_STR} ;;
    ${__LOG4SH_LEVEL_WARN}) _ltl__level=${__LOG4SH_LEVEL_WARN_STR} ;;
    ${__LOG4SH_LEVEL_ERROR}) _ltl__level=${__LOG4SH_LEVEL_ERROR_STR} ;;
    ${__LOG4SH_LEVEL_FATAL}) _ltl__level=${__LOG4SH_LEVEL_FATAL_STR} ;;
    ${__LOG4SH_LEVEL_OFF}) _ltl__level=${__LOG4SH_LEVEL_OFF_STR} ;;
    ${__LOG4SH_LEVEL_CLOSED}) _ltl__level=${__LOG4SH_LEVEL_CLOSED_STR} ;;
    *) _ltl__return=${__LOG4SH_FALSE} ;;
  esac

  echo ${_ltl__level}
  unset _ltl__val _ltl__level
  return ${_ltl__return}
}

#/**
# <s:function group="Level" modifier="public">
# <entry align="right">
#   <code>integer</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_level_toInt</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Converts an externally used level tag into its integer
#   equivalent</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>levelInt=`logger_level_toInt WARN`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_level_toInt()
{
  _lti__level=$1

  _lti__int=0
  _lti__return=${__LOG4SH_TRUE}

  case ${_lti__level} in
    ${__LOG4SH_LEVEL_TRACE_STR}) _lti__int=${__LOG4SH_LEVEL_TRACE} ;;
    ${__LOG4SH_LEVEL_DEBUG_STR}) _lti__int=${__LOG4SH_LEVEL_DEBUG} ;;
    ${__LOG4SH_LEVEL_INFO_STR}) _lti__int=${__LOG4SH_LEVEL_INFO} ;;
    ${__LOG4SH_LEVEL_WARN_STR}) _lti__int=${__LOG4SH_LEVEL_WARN} ;;
    ${__LOG4SH_LEVEL_ERROR_STR}) _lti__int=${__LOG4SH_LEVEL_ERROR} ;;
    ${__LOG4SH_LEVEL_FATAL_STR}) _lti__int=${__LOG4SH_LEVEL_FATAL} ;;
    ${__LOG4SH_LEVEL_OFF_STR}) _lti__int=${__LOG4SH_LEVEL_OFF} ;;
    ${__LOG4SH_LEVEL_CLOSED_STR}) _lti__int=${__LOG4SH_LEVEL_CLOSED} ;;
    *) _lti__return=${__LOG4SH_FALSE} ;;
  esac

  echo ${_lti__int}
  unset _lti__int _lti__level
  return ${_lti__return}
}

#=============================================================================
# Logger
#

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/<code>boolean</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_addAppender</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Add and initialize a new appender</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_addAppender $appender</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_addAppender()
{
  laa_appender=$1

  # FAQ should we be using setter functions here?? for performance, no.
  __log4shAppenders=`_log4sh_pushStack "${__log4shAppenders}" ${laa_appender}`
  __log4shAppenderCount=`expr ${__log4shAppenderCount} + 1`
  __log4shAppenderCounts="${__log4shAppenderCounts} ${__log4shAppenderCount}"
  __log4shAppenderLayouts=`_log4sh_pushStack \
      "$__log4shAppenderLayouts" "${__LOG4SH_LAYOUT_SIMPLE}"`
  __log4shAppenderLevels=`_log4sh_pushStack \
      "${__log4shAppenderLevels}" "${__LOG4SH_NULL}"`
  __log4shAppenderPatterns=`_log4sh_pushStack \
      "${__log4shAppenderPatterns}" "${__LOG4SH_PATTERN_DEFAULT}"`
  __log4shAppenderTypes=`_log4sh_pushStack \
      "${__log4shAppenderTypes}" ${__LOG4SH_TYPE_CONSOLE}`
  __log4shAppender_file_files=`_log4sh_pushStack \
      "${__log4shAppender_file_files}" ${__LOG4SH_NULL}`
  __log4shAppender_rollingFile_maxBackupIndexes=`_log4sh_pushStack \
      "${__log4shAppender_rollingFile_maxBackupIndexes}" \
      ${__LOG4SH_TYPE_ROLLING_FILE_MAX_BACKUP_INDEX}`
  __log4shAppender_rollingFile_maxFileSizes=`_log4sh_pushStack \
      "${__log4shAppender_rollingFile_maxFileSizes}" \
      ${__LOG4SH_TYPE_ROLLING_FILE_MAX_FILE_SIZE}`
  __log4shAppender_smtp_tos=`_log4sh_pushStack \
      "${__log4shAppender_smtp_tos}" ${__LOG4SH_NULL}`
  __log4shAppender_smtp_subjects=`_log4sh_pushStack \
      "${__log4shAppender_smtp_subjects}" ${__LOG4SH_NULL}`
  __log4shAppender_syslog_facilities=`_log4sh_pushStack \
      "${__log4shAppender_syslog_facilities}" ${__LOG4SH_TYPE_SYSLOG_FACILITY}`
  __log4shAppender_syslog_hosts=`_log4sh_pushStack \
      "${__log4shAppender_syslog_hosts}" "${__LOG4SH_NULL}"`

  _appender_cache ${laa_appender}

  unset laa_appender
  return ${__LOG4SH_TRUE}
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_addAppenderWithPattern</function></funcdef>
#       <paramdef>string <parameter>appender</parameter></paramdef>
#       <paramdef>string <parameter>pattern</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.6</emphasis></para>
#   <para>
#     Add and initialize a new appender with a specific PatternLayout
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_addAppenderWithPattern $appender '%d %p - %m%n'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_addAppenderWithPattern()
{
  _myAppender=$1
  _myPattern=$2

  logger_addAppender ${_myAppender}
  appender_setLayout ${_myAppender} ${__LOG4SH_LAYOUT_PATTERN}
  appender_setPattern ${_myAppender} "${_myPattern}"

  unset _myAppender _myPattern
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_getFilename</function></funcdef>
#       <void />
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Get the filename that would be shown when the '%F' conversion character
#     is used in a PatternLayout.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>filename=`logger_getFilename`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_getFilename()
{
  echo "${__log4sh_filename}"
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_setFilename</function></funcdef>
#       <paramdef>string <parameter>filename</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Set the filename to be shown when the '%F' conversion character is
#   used in a PatternLayout.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_setFilename 'myScript.sh'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_setFilename()
{
  __log4sh_filename=$1
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_getLevel</function></funcdef>
#       <void />
#     </funcprototype>
#   </funcsynopsis>
#   <para>Get the global default logging level (e.g. DEBUG).</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>level=`logger_getLevel`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_getLevel()
{
  logger_level_toLevel ${__log4shLevel}
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_setLevel</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Sets the global default logging level (e.g. DEBUG).</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_setLevel INFO</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_setLevel()
{
  _l_level=$1

  _l_int=`logger_level_toInt ${_l_level}`
  if [ $? -eq ${__LOG4SH_TRUE} ]; then
    __log4shLevel=${_l_int}
  else
    _log4sh_error "attempt to set invalid log level '${_l_level}'"
  fi

  unset _l_int _l_level
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>log</function></funcdef>
#       <paramdef>string <parameter>level</parameter></paramdef>
#       <paramdef>string[] <parameter>message(s)</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>The base logging command that logs a message to all defined
#     appenders</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>log DEBUG 'This is a test message'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
log()
{
  _l_level=$1
  shift
  # if no message was passed, read it from STDIN
  [ $# -ne 0 ] && _l_msg="$@" || _l_msg=`cat`

  __log4sh_return=${__LOG4SH_TRUE}
  _l_levelInt=`logger_level_toInt ${_l_level}`
  if [ $? -eq ${__LOG4SH_TRUE} ]; then
    # update seconds elapsed
    _log4sh_updateSeconds

    _l_oldIFS=${IFS} IFS=${__LOG4SH_IFS_DEFAULT}
    for _l_appenderIndex in ${__log4shAppenderCounts}; do
      ${__LOG4SH_TRACE} "_l_appenderIndex='${_l_appenderIndex}'"
      # determine appender level
      _l_appenderLevel=`_appender_getLevelByIndex ${_l_appenderIndex}`
      if [ "${_l_appenderLevel}" = "${__LOG4SH_NULL}" ]; then
        # continue if requested is level less than general level
        [ ! ${__log4shLevel} -le ${_l_levelInt} ] && continue
      else
        _l_appenderLevelInt=`logger_level_toInt ${_l_appenderLevel}`
        # continue if requested level is less than specific appender level
        ${__LOG4SH_TRACE} "_l_levelInt='${_l_levelInt}' _l_appenderLevelInt='${_l_appenderLevelInt}'"
        [ ! ${_l_appenderLevelInt} -le ${_l_levelInt} ] && continue
      fi

      # execute dynamic appender function
      _l_appenderName=`_log4sh_getArrayElement \
        "${__log4shAppenders}" ${_l_appenderIndex}`
      ${__LOG4SH_APPENDER_FUNC_PREFIX}${_l_appenderName}_append ${_l_level} "${_l_msg}"
    done
    IFS=${_l_oldIFS}
  else
    _log4sh_error "invalid logging level requested (${_l_level})"
    __log4sh_return=${__LOG4SH_ERROR}
  fi

  unset _l_msg _l_oldIFS _l_level _l_levelInt
  unset _l_appenderIndex _l_appenderLevel _l_appenderLevelInt _l_appenderName
  return ${__log4sh_return}
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_trace</function></funcdef>
#       <paramdef>string[] <parameter>message</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>This is a helper function for logging a message at the TRACE
#     priority</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_trace 'This is a trace message'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_trace()
{
  log ${__LOG4SH_LEVEL_TRACE_STR} "$@"
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_debug</function></funcdef>
#       <paramdef>string[] <parameter>message</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>This is a helper function for logging a message at the DEBUG
#     priority</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_debug 'This is a debug message'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_debug()
{
  log ${__LOG4SH_LEVEL_DEBUG_STR} "$@"
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_info</function></funcdef>
#       <paramdef>string[] <parameter>message</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>This is a helper function for logging a message at the INFO
#     priority</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_info 'This is a info message'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_info()
{
  log ${__LOG4SH_LEVEL_INFO_STR} "$@"
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_warn</function></funcdef>
#       <paramdef>string[] <parameter>message</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This is a helper function for logging a message at the WARN priority
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_warn 'This is a warn message'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_warn()
{
  log ${__LOG4SH_LEVEL_WARN_STR} "$@"
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_error</function></funcdef>
#       <paramdef>string[] <parameter>message</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This is a helper function for logging a message at the ERROR priority
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_error 'This is a error message'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_error()
{
  log ${__LOG4SH_LEVEL_ERROR_STR} "$@"
}

#/**
# <s:function group="Logger" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_fatal</function></funcdef>
#       <paramdef>string[] <parameter>message</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>This is a helper function for logging a message at the FATAL
#     priority</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_fatal 'This is a fatal message'</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_fatal()
{
  log ${__LOG4SH_LEVEL_FATAL_STR} "$@"
}

#==============================================================================
# Property
#

#/**
# <s:function group="Property" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_getPropPrefix</function></funcdef>
#       <paramdef>string <parameter>property</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Takes a string (eg. "log4sh.appender.stderr.File") and returns the
#   prefix of it (everything before the first '.' char). Normally used in
#   parsing the log4sh configuration file.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>prefix=`_log4sh_getPropPrefix $property"`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_getPropPrefix()
{
  _oldIFS=${IFS} IFS='.'
  set -- $1
  IFS=${_oldIFS} unset _oldIFS
  echo $1
}

#/**
# <s:function group="Property" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_stripPropPrefix</function></funcdef>
#       <paramdef>string <parameter>property</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Strips the prefix off a property configuration command and returns
#   the string. E.g. "log4sh.appender.stderr.File" becomes
#   "appender.stderr.File".</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>newProperty=`_log4sh_stripPropPrefix $property`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_stripPropPrefix()
{
  expr "$1" : '[^.]*\.\(.*\)'
}

#/**
# <s:function group="Property" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_propAlternative</function></funcdef>
#       <paramdef>string <parameter>property</parameter></paramdef>
#       <paramdef>string <parameter>value</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Configures log4sh to use an alternative command.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_propAlternative property value</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_propAlternative()
{
  _lpa_key=$1
  _lpa_value=$2

  # strip the leading 'alternative.'
  _lpa_alternative=`_log4sh_stripPropPrefix ${_lpa_key}`

  # set the alternative
  log4sh_setAlternative ${_lpa_alternative} "${_lpa_value}"

  unset _lpa_key _lpa_value _lpa_alternative
}

#/**
# <s:function group="Property" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_propAppender</function></funcdef>
#       <paramdef>string <parameter>property</parameter></paramdef>
#       <paramdef>string <parameter>value</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Configures log4sh using an appender property configuration statement</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_propAppender $property $value</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_propAppender()
{
  _lpa_key=$1
  _lpa_value=$2

  _lpa_appender=''
  _lpa_rtrn=${__LOG4SH_TRUE}

  # strip the leading 'appender' keyword prefix
  _lpa_key=`_log4sh_stripPropPrefix ${_lpa_key}`

  # handle appender definitions
  if [ "${_lpa_key}" '=' "`expr \"${_lpa_key}\" : '\([^.]*\)'`" ]; then
    _lpa_appender="${_lpa_key}"
  else
    _lpa_appender=`_log4sh_getPropPrefix ${_lpa_key}`
  fi

  # does the appender exist?
  appender_exists ${_lpa_appender}
  if [ $? -eq ${__LOG4SH_FALSE} ]; then
    _log4sh_error "attempt to configure the non-existant appender (${_lpa_appender})"
    unset _lpa_appender _lpa_key _lpa_value
    return ${__LOG4SH_ERROR}
  fi

  # handle the appender type
  if [ "${_lpa_appender}" = "${_lpa_key}" ]; then
    case ${_lpa_value} in
      ${__LOG4SH_TYPE_CONSOLE}|\
      ${__LOG4SH_CONFIG_LOG4J_CP}.${__LOG4SH_TYPE_CONSOLE})
        appender_setType ${_lpa_appender} ${__LOG4SH_TYPE_CONSOLE} ;;
      ${__LOG4SH_TYPE_FILE}|\
      ${__LOG4SH_CONFIG_LOG4J_CP}.${__LOG4SH_TYPE_FILE})
        appender_setType ${_lpa_appender} ${__LOG4SH_TYPE_FILE} ;;
      $__LOG4SH_TYPE_DAILY_ROLLING_FILE|\
      ${__LOG4SH_CONFIG_LOG4J_CP}.${__LOG4SH_TYPE_DAILY_ROLLING_FILE})
        appender_setType ${_lpa_appender} ${__LOG4SH_TYPE_DAILY_ROLLING_FILE} ;;
      ${__LOG4SH_TYPE_ROLLING_FILE}|\
      ${__LOG4SH_CONFIG_LOG4J_CP}.${__LOG4SH_TYPE_ROLLING_FILE})
        appender_setType ${_lpa_appender} ${__LOG4SH_TYPE_ROLLING_FILE} ;;
      ${__LOG4SH_TYPE_SMTP}|\
      ${__LOG4SH_CONFIG_LOG4J_CP}.${__LOG4SH_TYPE_SMTP})
        appender_setType $_lpa_appender ${__LOG4SH_TYPE_SMTP} ;;
      ${__LOG4SH_TYPE_SYSLOG}|\
      ${__LOG4SH_CONFIG_LOG4J_CP}.${__LOG4SH_TYPE_SYSLOG})
        appender_setType $_lpa_appender ${__LOG4SH_TYPE_SYSLOG} ;;
      *)
        _log4sh_error "appender type (${_lpa_value}) unrecognized"
        false
        ;;
    esac
    [ $? -ne ${__LOG4SH_TRUE} ] && _lpa_rtrn=${__LOG4SH_ERROR}
    __log4sh_return=${_lpa_rtrn}
    unset _lpa_appender _lpa_key _lpa_rtrn _lpa_value
    return ${__log4sh_return}
  fi

  # handle appender values and methods
  _lpa_key=`_log4sh_stripPropPrefix ${_lpa_key}`
  if [ "${_lpa_key}" '=' "`expr \"${_lpa_key}\" : '\([^.]*\)'`" ]; then
    case ${_lpa_key} in
      # General
      Threshold) appender_setLevel ${_lpa_appender} "${_lpa_value}" ;;
      layout) appender_setLayout ${_lpa_appender} "${_lpa_value}" ;;

      # FileAppender
      DatePattern) ;;  # unsupported
      File)
        _lpa_value=`eval echo "${_lpa_value}"`
        appender_file_setFile ${_lpa_appender} "${_lpa_value}"
        ;;
      MaxBackupIndex)
        appender_file_setMaxBackupIndex ${_lpa_appender} "${_lpa_value}" ;;
      MaxFileSize)
        appender_file_setMaxFileSize ${_lpa_appender} "${_lpa_value}" ;;

      # SMTPAppender
      To) appender_smtp_setTo ${_lpa_appender} "${_lpa_value}" ;;
      Subject) appender_smtp_setSubject ${_lpa_appender} "${_lpa_value}" ;;

      # SyslogAppender
      SyslogHost) appender_syslog_setHost ${_lpa_appender} "${_lpa_value}" ;;
      Facility) appender_syslog_setFacility ${_lpa_appender} "${_lpa_value}" ;;

      # catch unrecognized
      *)
        _log4sh_error "appender value/method (${_lpa_key}) unrecognized"
        false
        ;;
    esac
    [ $? -ne ${__LOG4SH_TRUE} ] && _lpa_rtrn=${__LOG4SH_ERROR}
    __log4sh_return=${_lpa_rtrn}
    unset _lpa_appender _lpa_key _lpa_rtrn _lpa_value
    return ${__log4sh_return}
  fi

  # handle appender layout values and methods
  _lpa_key=`_log4sh_stripPropPrefix ${_lpa_key}`
  case ${_lpa_key} in
    ConversionPattern) appender_setPattern ${_lpa_appender} "${_lpa_value}" ;;
    *)
      _log4sh_error "layout value/method (${_lpa_key}) unrecognized"
      false
      ;;
  esac
  [ $? -ne ${__LOG4SH_TRUE} ] && _lpa_rtrn=${__LOG4SH_ERROR}
  __log4sh_return=${_lpa_rtrn}
  unset _lpa_appender _lpa_key _lpa_rtrn _lpa_value
  return ${__log4sh_return}
}

#/**
# <s:function group="Property" modifier="private">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_propLogger</function></funcdef>
#       <paramdef>string <parameter>property</parameter></paramdef>
#       <paramdef>string <parameter>value</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>(future) Configures log4sh with a <code>logger</code> configuration
#   statement. Sample output: "logger: property value".</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>result=`_log4sh_propLogger $property $value`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_propLogger()
{
  _prop=`_log4sh_stripPropPrefix $1`
  echo "logger: ${_prop} $2"
  unset _prop
}

#
# configure log4sh with a rootLogger configuration statement
#
# @param  _key    configuration command
# @param  _value  configuration value
#
#/**
# <s:function group="Property" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_propRootLogger</function></funcdef>
#       <paramdef>string <parameter>rootLogger</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>Configures log4sh with a <code>rootLogger</code> configuration
#   statement. It expects a comma separated string similar to the following:</para>
#   <para><code>log4sh.rootLogger=ERROR, stderr, R</code></para>
#   <para>The first option is the default logging level to set for all
#   of the following appenders that will be created, and all following options
#   are the names of appenders to create. The appender names must be
#   unique.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_propRootLogger $value</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_propRootLogger()
{
  __lprl_rootLogger=`echo "$@" |sed 's/ *, */,/g'`
  __lprl_count=`echo "${__lprl_rootLogger}" |sed 's/,/ /g' |wc -w`
  __lprl_index=1
  while [ ${__lprl_index} -le ${__lprl_count} ]; do
    __lprl_operand=`echo "${__lprl_rootLogger}" |cut -d, -f${__lprl_index}`
    if [ ${__lprl_index} -eq 1 ]; then
      logger_setLevel "${__lprl_operand}"
    else
      appender_exists "${__lprl_operand}"
      if [ $? -eq ${__LOG4SH_FALSE} ]; then
        logger_addAppender "${__lprl_operand}"
      else
        _log4sh_error "attempt to add already existing appender of name (${__lprl_operand})"
      fi
    fi
    __lprl_index=`expr ${__lprl_index} + 1`
  done

  unset __lprl_count __lprl_index __lprl_operand __lprl_rootLogger
}

#/**
# <s:function group="Property" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>/boolean
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>log4sh_doConfigure</function></funcdef>
#       <paramdef>string <parameter>configFileName</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Read configuration from a file. <emphasis role="strong">The existing
#     configuration is not cleared or reset.</emphasis> If you require a
#     different behavior, then call the <code>log4sh_resetConfiguration</code>
#     before calling <code>log4sh_doConfigure</code>.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>log4sh_doConfigure myconfig.properties</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
log4sh_doConfigure()
{
  [ -n "${FUNCNAME:-}" ] \
      && ${__LOG4SH_TRACE} "${FUNCNAME}()${BASH_LINENO:+'(called from ${BASH_LINENO})'}"

  # prepare the environment for configuration
  log4sh_resetConfiguration

  ldc_file=$1
  ldc_rtrn=${__LOG4SH_TRUE}

  # strip the config prefix and dump output to a temporary file
  ldc_tmpFile="${__log4sh_tmpDir}/properties"
  ${__LOG4SH_TRACE} "__LOG4SH_CONFIG_PREFIX='${__LOG4SH_CONFIG_PREFIX}'"
  grep "^${__LOG4SH_CONFIG_PREFIX}\." "${ldc_file}" >"${ldc_tmpFile}"

  # read the file in. using a temporary file and a file descriptor here instead
  # of piping the file into the 'while read' because the pipe causes a fork
  # under some shells which makes it impossible to get the variables passed
  # back to the parent script.
  exec 3<&0 <"${ldc_tmpFile}"
  while read ldc_line; do
    ldc_key=`expr "${ldc_line}" : '\([^= ]*\) *=.*'`
    ldc_value=`expr "${ldc_line}" : '[^= ]* *= *\(.*\)'`

    # strip the leading 'log4sh.'
    ldc_key=`_log4sh_stripPropPrefix ${ldc_key}`
    ldc_keyword=`_log4sh_getPropPrefix ${ldc_key}`
    case ${ldc_keyword} in
      alternative) _log4sh_propAlternative ${ldc_key} "${ldc_value}" ;;
      appender) _log4sh_propAppender ${ldc_key} "${ldc_value}" ;;
      logger) _log4sh_propLogger ${ldc_key} "${ldc_value}" ;;
      rootLogger) _log4sh_propRootLogger "${ldc_value}" ;;
      *)
        _log4sh_error "unrecognized properties keyword (${ldc_keyword})"
        false
        ;;
    esac
    [ $? -ne ${__LOG4SH_TRUE} ] && ldc_rtrn=${__LOG4SH_ERROR}
  done
  exec 0<&3 3<&-

  # remove the temporary file
  rm -f "${ldc_tmpFile}"

  # activate all of the appenders
  for ldc_appender in ${__log4shAppenders}; do
    ${__LOG4SH_APPENDER_FUNC_PREFIX}${ldc_appender}_activateOptions
  done

  __log4sh_return=${ldc_rtrn}
  unset ldc_appender ldc_file ldc_tmpFile ldc_line ldc_key ldc_keyword
  unset ldc_value ldc_rtrn
  return ${__log4sh_return}
}

#/**
# <s:function group="Property" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>log4sh_readProperties</function></funcdef>
#       <paramdef>string <parameter>configFileName</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.6</emphasis></para>
#   <para>
#     See <code>log4sh_doConfigure</code>.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>log4sh_readProperties myconfig.properties</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
log4sh_readProperties()
{
  log4sh_doConfigure "$@"
}

#/**
# <s:function group="Property" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>log4sh_resetConfiguration</function></funcdef>
#       <void />
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     This function completely resets the log4sh configuration to have no
#     appenders with a global logging level of ERROR.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>log4sh_resetConfiguration</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
# XXX if a configuration is *repeatedly* established via logger_addAppender and
# reset using this command, there is a risk of running out of memory.
log4sh_resetConfiguration()
{
  __log4shAppenders=''
  __log4shAppenderCount=0
  __log4shAppenderCounts=''
  __log4shAppenderLayouts=''
  __log4shAppenderLevels=''
  __log4shAppenderPatterns=''
  __log4shAppenderTypes=''
  __log4shAppender_file_files=''
  __log4shAppender_rollingFile_maxBackupIndexes=''
  __log4shAppender_rollingFile_maxFileSizes=''
  __log4shAppender_smtp_tos=''
  __log4shAppender_smtp_subjects=''
  __log4shAppender_syslog_facilities=''
  __log4shAppender_syslog_hosts=''

  logger_setLevel ERROR
}

#==============================================================================
# Thread
#

#/**
# <s:function group="Thread" modifier="public">
# <entry align="right">
#   <code>string</code>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_getThreadName</function></funcdef>
#       <void />
#     </funcprototype>
#   </funcsynopsis>
#   <para>Gets the current thread name.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>threadName=`logger_getThreadName`</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_getThreadName()
{
  echo ${__log4sh_threadName}
}

#/**
# <s:function group="Thread" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_setThreadName</function></funcdef>
#       <paramdef>string <parameter>threadName</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>
#     Sets the thread name (e.g. the name of the script). This thread name can
#     be used with the '%t' conversion character within a
#     <option>PatternLayout</option>.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_setThreadName "myThread"</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_setThreadName()
{
  _thread=$1

  _length=`_log4sh_getArrayLength "$__log4sh_threadStack"`
  __log4sh_threadStack=`_log4sh_setArrayElement "$__log4sh_threadStack" $_length $_thread`
  __log4sh_threadName=$_thread

  unset _length _thread
}

#/**
# <s:function group="Thread" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_pushThreadName</function></funcdef>
#       <paramdef>string <parameter>threadName</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.7</emphasis></para>
#   <para>
#     Sets the thread name (eg. the name of the script) and pushes the old on
#     to a stack for later use. This thread name can be used with the '%t'
#     conversion character within a <option>PatternLayout</option>.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_pushThreadName "myThread"</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_pushThreadName()
{
  __log4sh_threadStack=`_log4sh_pushStack "$__log4sh_threadStack" $1`
  __log4sh_threadName=$1
}

#/**
# <s:function group="Thread" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>logger_popThreadName</function></funcdef>
#       <void />
#     </funcprototype>
#   </funcsynopsis>
#   <para><emphasis role="strong">Deprecated as of 1.3.7</emphasis></para>
#   <para>
#     Removes the topmost thread name from the stack. The next thread name on
#     the stack is then placed in the <varname>__log4sh_threadName</varname>
#     variable. If the stack is empty, or has only one element left, then a
#     warning is given that no more thread names can be popped from the stack.
#   </para>
#   <funcsynopsis>
#     <funcsynopsisinfo>logger_popThreadName</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
logger_popThreadName()
{
  _length=`_log4sh_getArrayLength "$__log4sh_threadStack"`
  if [ $_length -gt 1 ]; then
    __log4sh_threadStack=`_log4sh_popStack "$__log4sh_threadStack"`
    __log4sh_threadName=`_log4sh_peekStack "$__log4sh_threadStack"`
  else
    echo 'log4sh:WARN no more thread names available on thread name stack.' >&2
  fi
}

#==============================================================================
# Trap
#

#/**
# <s:function group="Trap" modifier="public">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>log4sh_cleanup</function></funcdef>
#       <void />
#     </funcprototype>
#   </funcsynopsis>
#   <para>This is a cleanup function to remove the temporary directory used by
#   log4sh. It is provided for scripts who want to do log4sh cleanup work
#   themselves rather than using the automated cleanup of log4sh that is
#   invoked upon a normal exit of the script.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>log4sh_cleanup</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
log4sh_cleanup()
{
  _log4sh_cleanup 'EXIT'
}

#/**
# <s:function group="Trap" modifier="private">
# <entry align="right">
#   <emphasis>void</emphasis>
# </entry>
# <entry>
#   <funcsynopsis>
#     <funcprototype>
#       <funcdef><function>_log4sh_cleanup</function></funcdef>
#       <paramdef>string <parameter>signal</parameter></paramdef>
#     </funcprototype>
#   </funcsynopsis>
#   <para>This is a cleanup function to remove the temporary directory used by
#   log4sh. It should only be called by log4sh itself when it is taking
#   control of traps.</para>
#   <para>If there was a previously defined trap for the given signal, log4sh
#   will attempt to call the original trap handler as well so as not to break
#   the parent script.</para>
#   <funcsynopsis>
#     <funcsynopsisinfo>_log4sh_cleanup EXIT</funcsynopsisinfo>
#   </funcsynopsis>
# </entry>
# </s:function>
#*/
_log4sh_cleanup()
{
  _lc__trap=$1
  ${__LOG4SH_INFO} "_log4sh_cleanup(): the ${_lc__trap} signal was caught"

  _lc__restoreTrap=${__LOG4SH_FALSE}
  _lc__oldTrap=''

  # match trap to signal value
  case "${_lc__trap}" in
    EXIT) _lc__signal=0 ;;
    INT) _lc__signal=2 ;;
    TERM) _lc__signal=15 ;;
  esac

  # do we possibly need to restore a previous trap?
  if [ -r "${__log4sh_trapsFile}" -a -s "${__log4sh_trapsFile}" ]; then
    # yes. figure out what we need to do
    if [ `grep "^trap -- " "${__log4sh_trapsFile}" >/dev/null; echo $?` -eq 0 ]
    then
      # newer trap command
      ${__LOG4SH_DEBUG} 'newer POSIX trap command'
      _lc__restoreTrap=${__LOG4SH_TRUE}
      _lc__oldTrap=`egrep "(${_lc__trap}|${_lc__signal})$" "${__log4sh_trapsFile}" |\
        sed "s/^trap -- '\(.*\)' [A-Z]*$/\1/"`
    elif [ `grep "[0-9]*: " "${__log4sh_trapsFile}" >/dev/null; echo $?` -eq 0 ]
    then
      # older trap command
      ${__LOG4SH_DEBUG} 'older style trap command'
      _lc__restoreTrap=${__LOG4SH_TRUE}
      _lc__oldTrap=`grep "^${_lc__signal}: " "${__log4sh_trapsFile}" |\
        sed 's/^[0-9]*: //'`
    else
      # unrecognized trap output
      _log4sh_error 'unable to restore old traps! unrecognized trap command output'
    fi
  fi

  # do our work
  rm -fr "${__log4sh_tmpDir}"

  # execute the old trap
  if [ ${_lc__restoreTrap} -eq ${__LOG4SH_TRUE} -a -n "${_lc__oldTrap}" ]; then
    ${__LOG4SH_INFO} 'restoring previous trap of same type'
    eval "${_lc__oldTrap}"
  fi

  # exit for all non-EXIT signals
  if [ "${_lc__trap}" != 'EXIT' ]; then
    # disable the EXIT trap
    trap 0

    # add 127 to signal value and exit
    _lc__signal=`expr ${_lc__signal} + 127`
    exit ${_lc__signal}
  fi

  unset _lc__oldTrap _lc__signal _lc__restoreTrap _lc__trap
  return
}


#==============================================================================
# main
#

# create a temporary directory
__log4sh_tmpDir=`_log4sh_mktempDir`

# preserve old trap(s)
__log4sh_trapsFile="${__log4sh_tmpDir}/traps"
trap >"${__log4sh_trapsFile}"

# configure traps
${__LOG4SH_INFO} 'setting traps'
trap '_log4sh_cleanup EXIT' 0
trap '_log4sh_cleanup INT' 2
trap '_log4sh_cleanup TERM' 15

# alternative commands
log4sh_setAlternative mail "${LOG4SH_ALTERNATIVE_MAIL:-mail}" ${__LOG4SH_TRUE}
[ -n "${LOG4SH_ALTERNATIVE_NC:-}" ] \
    && log4sh_setAlternative nc "${LOG4SH_ALTERNATIVE_NC}"

# load the properties file
${__LOG4SH_TRACE} "__LOG4SH_CONFIGURATION='${__LOG4SH_CONFIGURATION}'"
if [ "${__LOG4SH_CONFIGURATION}" != 'none' -a -r "${__LOG4SH_CONFIGURATION}" ]
then
  ${__LOG4SH_INFO} 'configuring via properties file'
  log4sh_doConfigure "${__LOG4SH_CONFIGURATION}"
else
  if [ "${__LOG4SH_CONFIGURATION}" != 'none' ]; then
    _log4sh_warn 'No appenders could be found.'
    _log4sh_warn 'Please initalize the log4sh system properly.'
  fi
  ${__LOG4SH_INFO} 'configuring at runtime'

  # prepare the environment for configuration
  log4sh_resetConfiguration

  # note: not using the constant variables here (e.g. for ConsoleAppender) so
  # that those perusing the code can have a working example
  logger_setLevel ${__LOG4SH_LEVEL_ERROR_STR}
  logger_addAppender stdout
  appender_setType stdout ConsoleAppender
  appender_setLayout stdout PatternLayout
  appender_setPattern stdout '%-4r [%t] %-5p %c %x - %m%n'
fi

# restore the previous set of shell flags
for _log4sh_shellFlag in ${__LOG4SH_SHELL_FLAGS}; do
  echo ${__log4sh_oldShellFlags} |grep ${_log4sh_shellFlag} >/dev/null \
    || set +${_log4sh_shellFlag}
done
unset _log4sh_shellFlag

#/**
# </s:shelldoc>
#*/
