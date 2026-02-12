%%
%% %CopyrightBegin%
%%
%% SPDX-License-Identifier: Apache-2.0
%%
%% Copyright Ericsson AB 2007-2025. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%
%% %CopyrightEnd%
%%

%%

%%% Description: Dummy Callback module for ssh_sftpd to test
%%% the possibility to switch file handling implementation.

-module(ssh_sftpd_file_alt).

-behaviour(ssh_sftpd_file_api).

%% API
-export([init/2, close/2, delete/2, del_dir/2, get_cwd/1, is_dir/2, list_dir/2,
	 make_dir/2, make_symlink/3, open/3, position/3, read/3,
	 read_file_info/2, read_link/2, read_link_info/2, rename/3,
	 write/3, write_file_info/3]).

init(_State, HandlerContext) when is_list(HandlerContext) ->
    Pid = proplists:get_value(me, HandlerContext),
    Pid ! alt_init,
    Pid.

close(IoDevice, State) ->
    State ! alt_close,
    {file:close(IoDevice), State}.

delete(Path, State) ->
    State ! alt_delete,
    {file:delete(Path), State}.

del_dir(Path, State) ->
    State ! alt_del_dir,
    {file:del_dir(Path), State}.

get_cwd(State) ->
    {file:get_cwd(), State}.

is_dir(AbsPath, State) ->
    %State ! alt_is_dir,
    {filelib:is_dir(AbsPath), State}.

list_dir(AbsPath, State) ->
    State ! alt_list_dir,
    {file:list_dir(AbsPath), State}.

make_dir(Dir, State) ->
    State ! alt_make_dir,
    {file:make_dir(Dir), State}.

make_symlink(Path2, Path, State) ->
    State ! alt_make_symlink,
    {file:make_symlink(Path2, Path), State}.

open(Path, Flags, State) ->
    State ! alt_open,
    {file:open(Path, Flags), State}.

position(IoDevice, Offs, State) ->
    State ! alt_position,
    {file:position(IoDevice, Offs), State}.

read(IoDevice, Len, State) ->
    State ! alt_read,
    {file:read(IoDevice, Len), State}.

read_link(Path, State) ->
    State ! alt_read_link,
    {file:read_link(Path), State}.

read_link_info(Path, State) ->
    State ! alt_read_link_info,
    {file:read_link_info(Path), State}.

read_file_info(Path, State) ->
    State ! alt_read_file_info,
    {file:read_file_info(Path), State}.

rename(Path, Path2, State) ->
    State ! alt_rename,
    {file:rename(Path, Path2), State}.

write(IoDevice, Data, State) ->
    State ! alt_write,
    {file:write(IoDevice, Data), State}.

write_file_info(Path,Info, State) ->
    State ! alt_write_file_info,
    {file:write_file_info(Path, Info), State}.
